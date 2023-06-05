/**
 *  $$$$$$\  $$\                 $$\                           
 * $$  __$$\ $$ |                $$ |                          
 * $$ /  \__|$$$$$$$\   $$$$$$\  $$ |  $$\  $$$$$$\   $$$$$$\  
 * \$$$$$$\  $$  __$$\  \____$$\ $$ | $$  |$$  __$$\ $$  __$$\ 
 *  \____$$\ $$ |  $$ | $$$$$$$ |$$$$$$  / $$$$$$$$ |$$ |  \__|
 * $$\   $$ |$$ |  $$ |$$  __$$ |$$  _$$<  $$   ____|$$ |      
 * \$$$$$$  |$$ |  $$ |\$$$$$$$ |$$ | \$$\ \$$$$$$$\ $$ |      
 *  \______/ \__|  \__| \_______|\__|  \__| \_______|\__|
 * $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 * ____________________________________________________________
*/

pragma solidity >=0.4.23 <0.6.0;

import "./interfaces/ShakerTokenManagerInterface.sol";
import "./interfaces/VaultInterface.sol";
import "./interfaces/DisputeInterface.sol";
import "./interfaces/ERC20Interface.sol";
import "./interfaces/DisputeManagerInterface.sol";

import "./ReentrancyGuard.sol";
import "./StringUtils.sol";
import "./Mocks/SafeMath.sol";

contract ShakerV2 is ReentrancyGuard, StringUtils {
    using SafeMath for uint256;

    address public operator;            // Super operator account to control the contract
    address public tokenAddress;        // USDT token

    ShakerTokenManagerInterface public tokenManager;
    
    address public vaultAddress;
    VaultInterface public vault;
    
    address public disputeManagerAddress;
    DisputeManagerInterface public disputeManager;

    mapping(address => address) private relayerWithdrawAddress;
    
    // If the msg.sender(relayer) has not registered Withdrawal address, the fee will send to this address
    address public commonWithdrawAddress; 
    
    // exchange rate for other crypto currency with usdt, 100000000 means 1 by 1, if btc is $40,000, this param will be 40,000 * 1e8
    // if a token is 0.00123 usdt, this param will be 0.00123 * 1e8 = 123,000
    uint256 public exchangeRate = 1e8;
    
    modifier onlyOperator {
        require(msg.sender == operator, "Only operator can call this function.");
        _;
    }

    modifier onlyRelayer {
        require(relayerWithdrawAddress[msg.sender] != address(0x0), "Only relayer can call this function.");
        _;
    }
    
    constructor(
        address _operator,
        address _commonWithdrawAddress,
        address _vaultAddress,
        address _tokenAddress
    ) public {
        operator = _operator;
        commonWithdrawAddress = _commonWithdrawAddress;
        vaultAddress = _vaultAddress;
        vault = VaultInterface(vaultAddress);
        disputeManager = DisputeManagerInterface(disputeManagerAddress);
        tokenAddress = _tokenAddress;
    }

    function depositERC20Batch(
        bytes32[] calldata _hashKey,
        uint256[] calldata _amounts, 
        uint256[] calldata _effectiveTime
    ) external payable nonReentrant {
        for(uint256 i = 0; i < _amounts.length; i++) {
            _deposit(_hashKey[i], _amounts[i], _effectiveTime[i]);
        }
    }
  
    function _deposit(
        bytes32 _hashKey,
        uint256 _amount, 
        uint256 _effectiveTime
    ) internal {
        require(vault.getStatus(_hashKey) == 0, "The commitment has been submitted or used out.");
        require(_amount > 0);
        
        _processDeposit(_amount, vaultAddress);
        
        vault.setStatus(_hashKey, 1);
        vault.setAmount(_hashKey, _amount);
        vault.setSender(_hashKey, msg.sender);
        vault.setEffectiveTime(_hashKey, _effectiveTime < block.timestamp ? block.timestamp : _effectiveTime);
        vault.setTimestamp(_hashKey, block.timestamp);
        vault.setCanEndorse(_hashKey, 0);
        vault.setLockable(_hashKey, 1);
        
        vault.addTotalAmount(_amount);
        vault.addTotalBalance(_amount);

        vault.sendDepositEvent(msg.sender, _hashKey, _amount, block.timestamp);
    }

    function _processDeposit(uint256 _amount, address _to) internal;
    
    function withdrawERC20Batch(
        bytes32[] calldata _commitments,
        uint256[] calldata _amounts,
        uint256[] calldata _fees,
        address[] calldata _relayers
    ) external payable nonReentrant {
        for(uint256 i = 0; i < _commitments.length; i++) _withdraw(bytes32ToString(_commitments[i]), _amounts[i], _fees[i], _relayers[i]);
    }
    
    function _withdraw(
        string memory _commitment,
        uint256 _amount,                // Withdrawal amount
        uint256 _fee,                    // Fee caculated by relayer
        address _relayer                // Relayer address
    ) internal {
        bytes32 _hashkey = getHashkey(_commitment);
        require(vault.getAmount(_hashkey) > 0, 'The commitment of this recipient is not exist or used out');
        require(disputeManager.getStatus(_hashkey) != 1, 'This deposit was locked');
        require(_amount == vault.getAmount(_hashkey), "amount must be exactly as balance");
        uint256 refundAmount = _amount;
        require(refundAmount > 0, "Refund amount can not be zero");
        require(block.timestamp >= vault.getEffectiveTime(_hashkey), "The deposit is locked until the effectiveTime");
        require(refundAmount >= _fee, "Refund amount should be more than fee");

        address relayer = relayerWithdrawAddress[_relayer] == address(0x0) ? commonWithdrawAddress : relayerWithdrawAddress[_relayer];
        uint256 decimals = ERC20Interface(tokenAddress).decimals();
        uint256 _usdFee = tokenManager.getFee(refundAmount.mul(exchangeRate).div(1e8).div(10**(decimals.sub(6))));
        uint256 _fee1 = _usdFee.mul(10**(decimals.add(2))).div(exchangeRate);
        require(_fee1 <= refundAmount, "The fee can not be more than refund amount");
        uint256 _fee2 = relayerWithdrawAddress[_relayer] == address(0x0) ? _fee1 : _fee; // If not through relay, use commonFee
        _processWithdraw(msg.sender, relayer, _fee2, refundAmount);
    
        vault.setAmount(_hashkey, vault.getAmount(_hashkey).sub(refundAmount));
        vault.setStatus(_hashkey, vault.getAmount(_hashkey) <= 0 ? 0 : 1);
        vault.subTotalBalance(refundAmount);

        uint256 _hours = (block.timestamp.sub(vault.getTimestamp(_hashkey))).div(3600);
        tokenManager.sendBonus(refundAmount.mul(exchangeRate).div(1e8), decimals, _hours, vault.getSender(_hashkey), msg.sender);
        
        vault.sendWithdrawEvent(_commitment, _fee, refundAmount, block.timestamp);
    }

    function _processWithdraw(address payable _recipient, address _relayer, uint256 _fee, uint256 _refund) internal;

    function getHashkey(string memory _commitment) internal view returns(bytes32) {
        string memory commitAndTo = concat(_commitment, addressToString(msg.sender));
        return keccak256(abi.encodePacked(commitAndTo));
    }

    function endorseERC20Batch(
        uint256[] calldata _amounts,
        bytes32[] calldata _oldCommitments,
        bytes32[] calldata _newHashKeys,
        uint256[] calldata _effectiveTimes
    ) external payable nonReentrant {
        for(uint256 i = 0; i < _amounts.length; i++) _endorse(_amounts[i], bytes32ToString(_oldCommitments[i]), _newHashKeys[i], _effectiveTimes[i]);
    }
    
    function _endorse(
        uint256 _amount, 
        string memory _oldCommitment, 
        bytes32 _newHashKey, 
        uint256 _effectiveTime
    ) internal {
        bytes32 _oldHashKey = getHashkey(_oldCommitment);
        require(disputeManager.getStatus(_oldHashKey) != 1, 'This deposit was locked');
        require(vault.getStatus(_oldHashKey) == 1, "Old commitment can not find");
        require(vault.getStatus(_newHashKey) == 0, "The new commitment has been submitted or used out");
        require(vault.getCanEndorse(_oldHashKey) == 1, "Old commitment can not endorse");
        require(vault.getAmount(_oldHashKey) > 0, "No balance amount of this proof");
        uint256 refundAmount = _amount < vault.getAmount(_oldHashKey) ? _amount : vault.getAmount(_oldHashKey); //Take all if _refund == 0
        require(refundAmount > 0, "Refund amount can not be zero");

        if(_effectiveTime > 0 && block.timestamp >= vault.getEffectiveTime(_oldHashKey)) vault.setEffectiveTime(_oldHashKey,  _effectiveTime); // Effective
        else vault.setEffectiveTime(_newHashKey, vault.getEffectiveTime(_oldHashKey)); // Not effective
        
        vault.setStatus(_newHashKey, 1);
        vault.setAmount(_newHashKey, refundAmount);
        vault.setSender(_newHashKey, msg.sender);
        vault.setTimestamp(_newHashKey, block.timestamp);
        vault.setCanEndorse(_newHashKey, 0);
        vault.setLockable(_newHashKey, 1);
        
        vault.setAmount(_oldHashKey, vault.getAmount(_oldHashKey).sub(refundAmount));
        vault.setStatus(_oldHashKey, vault.getAmount(_oldHashKey) <= 0 ? 0 : 1);

        vault.sendWithdrawEvent(_oldCommitment,  0, refundAmount, block.timestamp);
        vault.sendDepositEvent(msg.sender, _newHashKey, refundAmount, block.timestamp);
    }
    
    /** @dev whether a note is already spent */
    function isSpent(bytes32 _hashkey) public view returns(bool) {
        return vault.getAmount(_hashkey) == 0 ? true : false;
    }

    /** @dev whether an array of notes is already spent */
    function isSpentArray(bytes32[] calldata _hashkeys) external view returns(bool[] memory spent) {
        spent = new bool[](_hashkeys.length);
        for(uint i = 0; i < _hashkeys.length; i++) spent[i] = isSpent(_hashkeys[i]);
    }

    /** @dev operator can change his address */
    function updateOperator(address _newOperator) external nonReentrant onlyOperator {
        operator = _newOperator;
    }

    /** @dev update authority relayer */
    function updateRelayer(address _relayer, address _withdrawAddress) external nonReentrant onlyOperator {
        relayerWithdrawAddress[_relayer] = _withdrawAddress;
    }
    
    /** @dev get relayer Withdrawal address */
    function getRelayerWithdrawAddress() view external onlyRelayer returns(address) {
        return relayerWithdrawAddress[msg.sender];
    }
    
    /** @dev update commonWithdrawAddress */
    function updateCommonWithdrawAddress(address _commonWithdrawAddress) external nonReentrant onlyOperator {
        commonWithdrawAddress = _commonWithdrawAddress;
    }
    
    /**
     * Cancel effectiveTime and change cheque to at sight
     */
    function changeToAtSight(bytes32 _hashkey) external nonReentrant returns(bool) {
        require(msg.sender == vault.getSender(_hashkey), 'Only sender can change this cheque to at sight');
        if(vault.getEffectiveTime(_hashkey) > block.timestamp) {
          vault.setEffectiveTime(_hashkey, block.timestamp);
          vault.setLockable(_hashkey, 0);
          vault.setCanEndorse(_hashkey, 1);
        }
        return true;
    }
    
    function setCanEndorse(bytes32 _hashkey, uint256 status) external nonReentrant returns(bool) {
        require(msg.sender == vault.getSender(_hashkey), 'Only sender can change endorsable');
        vault.setCanEndorse(_hashkey, status);
        return true;
    }

    function setLockable(bytes32 _hashKey, uint256 status) external nonReentrant returns(bool) {
        require(msg.sender == vault.getSender(_hashKey), 'Only sender can change lockable');
        require(vault.getLockable(_hashKey) == 1 && status == 0, 'Can only change from lockable to non-lockable');
        vault.setLockable(_hashKey, status);
        vault.setCanEndorse(_hashKey, 1);
        return true;
    }

    function getDepositDataByHashkey(bytes32 _hashkey) external view returns(uint256 effectiveTime, uint256 amount, uint256 lockable, uint256 canEndorse) {
        effectiveTime = vault.getEffectiveTime(_hashkey);
        amount = vault.getAmount(_hashkey);
        lockable = vault.getLockable(_hashkey);
        canEndorse = vault.getCanEndorse(_hashkey);
    }
    
    function updateBonusTokenManager(address _BonusTokenManagerAddress) external nonReentrant onlyOperator {
        tokenManager = ShakerTokenManagerInterface(_BonusTokenManagerAddress);
    }
    
    function updateVault(address _vaultAddress) external nonReentrant onlyOperator {
        vaultAddress = _vaultAddress;
        vault = VaultInterface(_vaultAddress);
    }
    function updateDisputeManager(address _disputeManagerAddress) external nonReentrant onlyOperator {
        disputeManagerAddress = _disputeManagerAddress;
        disputeManager = DisputeManagerInterface(disputeManagerAddress);
    }
    function updateExchangeRate(uint256 _rate) external nonReentrant onlyOperator {
        exchangeRate = _rate;
    }
}
