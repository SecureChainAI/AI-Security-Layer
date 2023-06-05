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

import "./ReentrancyGuard.sol";
import "./Mocks/TransferHelper.sol";
import "./Mocks/SafeMath.sol";
import "./interfaces/VaultInterface.sol";
import "./interfaces/DisputeInterface.sol";
import "./interfaces/ERC20Interface.sol";
import "./StringUtils.sol";

contract DisputeManager is ReentrancyGuard, StringUtils {
    using TransferHelper for *;
    using SafeMath for uint256;

    address public operator;            // Super operator account to control the contract
    address public councilAddress;      // Council address of DAO
    address public tokenAddress;        // USDT
    address public disputeAddress;
    address public vaultAddress;
    address public shakerAddress;
    
    VaultInterface public vault;
    DisputeInterface public dispute;
    
    uint256 public compensationRate = 2000;
    uint256 public minReplyHours = 24;
    uint256 public councilJudgementFee = 0; // Council charge for judgement
    uint256 public councilJudgementFeeRate = 1700; // If the desired rate is 17%, commonFeeRate should set to 1700

    modifier onlyCouncil {
        require(msg.sender == councilAddress, "Only council account can call this function.");
        _;
    }
    modifier onlyOperator {
        require(msg.sender == operator, "Only operator can call this function.");
        _;
    }
    
    modifier onlyShaker {
        require(msg.sender == shakerAddress, "Only Shaker contract can call this function");
        _;
    }

    constructor(
        address _shakerAddress,
        address _tokenAddress,
        address _vaultAddress,
        address _disputeAddress
    ) public {
        operator = msg.sender;
        shakerAddress = _shakerAddress;
        vaultAddress = _vaultAddress;
        vault = VaultInterface(_vaultAddress);
        disputeAddress = _disputeAddress;
        dispute = DisputeInterface(_disputeAddress);
        councilAddress = msg.sender;
        tokenAddress = _tokenAddress;
    }
    
    function lockERC20Batch (
        bytes32             _hashkey,
        uint256             _refund,
        string   calldata   _description,
        address payable     _recipient,
        uint256             _replyHours
    ) external payable nonReentrant {
        lock(_hashkey, _refund, _description, _recipient, _replyHours);
    }

    function lock(
        bytes32 _hashkey,
        uint256 _refund,
        string memory _description,
        address payable _recipient,
        uint256 _replyHours
    ) internal {
        require(msg.sender == vault.getSender(_hashkey), 'Locker must be sender');
        require(vault.getLockable(_hashkey) == 1, 'This commitment must be lockable');
        require(vault.getAmount(_hashkey) >= _refund, 'Balance amount must be enough');
        require(_replyHours >= minReplyHours, 'The reply days less than minReplyHours');
        
        // lock arbitration margin to Dispute contract
        uint256 balance = ERC20Interface(tokenAddress).balanceOf(msg.sender);
        uint256 refund = _refund == 0 ? vault.getAmount(_hashkey) : _refund;
        uint256 judgementFee = getJudgementFee(refund);
        require(balance >= judgementFee, "Sender balance is enough for arbitration ");
        TransferHelper.safeTransferFrom(tokenAddress, msg.sender, disputeAddress, judgementFee);

        dispute.initLockReason(
            _hashkey,
            _description, 
            _replyHours * 3600 + block.timestamp,
            refund,
            msg.sender,
            _recipient,
            judgementFee
        );
    }
    
    function unlockByCouncil(bytes32 _hashkey, uint8 _result) external nonReentrant onlyCouncil {
        // _result = 1: sender win
        // _result = 2: recipient win
        require(_result == 1 || _result == 2);
        
        if(dispute.getStatus(_hashkey) == 1 && dispute.getToCouncil(_hashkey) == 1) {
            dispute.setStatus(_hashkey, 3);
            uint256 councilFee = dispute.getFee(_hashkey);
            uint256 compensation = councilFee.mul(compensationRate).div(10000);
            if(_result == 1) {
                // If the council decided to return back money to the sender
                uint256 refund = dispute.getRefund(_hashkey);
                address payable sender = dispute.getLocker(_hashkey);
                TransferHelper.safeTransferFrom(tokenAddress, vaultAddress, sender, refund);
                dispute.sendFeeTo(tokenAddress, sender, councilFee.add(compensation)); // return back arbitration fee deposit and compensation from recipient
                dispute.sendFeeTo(tokenAddress, councilAddress, councilFee.sub(compensation)); // send arbitration fee from recipient to councilAddress
                vault.subTotalBalance(refund);
                vault.setAmount(_hashkey, vault.getAmount(_hashkey).sub(refund));
                vault.setStatus(_hashkey, vault.getAmount(_hashkey) == 0 ? 0 : 1);
            } else {
                dispute.setStatus(_hashkey, 3);
                address recipient = dispute.getRecipient(_hashkey);
                dispute.sendFeeTo(tokenAddress, recipient, councilFee.add(compensation));  // return back arbitration fee and compensation from sender to recipient
                dispute.sendFeeTo(tokenAddress, councilAddress, councilFee.sub(compensation));  // send arbitration fee from sender to councilAddress
                vault.subTotalBalance(councilFee);
                vault.setAmount(_hashkey, vault.getAmount(_hashkey).sub(councilFee));
                vault.setStatus(_hashkey, vault.getAmount(_hashkey) == 0 ? 0 : 1);
            }
        }
    }

    /**
     * recipient should agree to let sender refund, otherwise, will bring to the council to make a judgement
     * This is 1st step if dispute happend
     * status: 1 - deny, 2 - accept, 3 - dealing time passed
     */
    function unlockByRecipent(bytes32 _hashkey, bytes32 _commitment, uint8 _status) external nonReentrant {
        bytes32 _recipientHashKey = getHashkey(bytes32ToString(_commitment));
        uint256 isSender = msg.sender == vault.getSender(_hashkey) ? 1 : 0; // ######
        uint256 isRecipent = _hashkey == _recipientHashKey ? 1 : 0;

        require(isSender == 1 || isRecipent == 1, 'Must be called by recipient or original sender');
        require(_status == 1 || _status == 2 || _status == 3, 'params can only be 1,2,3');
        require(dispute.getStatus(_hashkey) == 1, 'This commitment is not locked');

        if(isSender == 1 && block.timestamp >= dispute.getDatetime(_hashkey) && _status != 3) {
            // Sender accept to keep cheque available
            dispute.setStatus(_hashkey, _status == 2 ? 4 : 1);
            if(_status == 2) {
                // cancel refund and return back arbitration fee
                dispute.sendFeeTo(tokenAddress, dispute.getLocker(_hashkey), dispute.getFee(_hashkey));
                if(dispute.getToCouncil(_hashkey) == 1) dispute.sendFeeTo(tokenAddress, dispute.getRecipient(_hashkey), dispute.getFee(_hashkey));
            }
            dispute.setToCouncil(_hashkey, _status == 1 ? 1 : 0);
        } else if(isSender == 1 && block.timestamp >= dispute.getReplyDeadline(_hashkey) && _status == 3) {
            // Sender can refund after reply deadline
            dispute.setStatus(_hashkey, 5);
        } else if(isRecipent == 1 && block.timestamp >= dispute.getDatetime(_hashkey) && block.timestamp <= dispute.getReplyDeadline(_hashkey)) {
            // recipient accept or refuse to refund back to sender
            if(_status == 1) {
                // refuse to refund
                address payable recipient = dispute.getRecipient(_hashkey);
                uint256 balance = ERC20Interface(tokenAddress).balanceOf(recipient);
                uint256 judgementFee =  getJudgementFee(dispute.getRefund(_hashkey));
                require(balance >= judgementFee, "recipient balance is enough for arbitration ");
                TransferHelper.safeTransferFrom(tokenAddress, msg.sender, disputeAddress, judgementFee);
            }
            dispute.setStatus(_hashkey, _status);
            dispute.setRecipientAgree(_hashkey, _status == 2 ? 1 : 0);
            dispute.setToCouncil(_hashkey, _status == 1 ? 1 : 0);
        }
        // return back to sender
        if(dispute.getStatus(_hashkey) == 2 || dispute.getStatus(_hashkey) == 5) {
            uint256 refund = dispute.getRefund(_hashkey);
            TransferHelper.safeTransferFrom(tokenAddress, vaultAddress, vault.getSender(_hashkey), refund);
            dispute.sendFeeTo(tokenAddress, vault.getSender(_hashkey), dispute.getFee(_hashkey));
            vault.subTotalBalance(refund);
            vault.setAmount(_hashkey, vault.getAmount(_hashkey).sub(refund));
            vault.setStatus(_hashkey, vault.getAmount(_hashkey) == 0 ? 0 : 1);
        }
    }

    function getStatus(bytes32 _hashkey) public view returns(uint256) {
        return dispute.getStatus(_hashkey);
    }
    function getHashkey(string memory _commitment) internal view returns(bytes32) {
        string memory commitAndTo = concat(_commitment, addressToString(msg.sender));
        return keccak256(abi.encodePacked(commitAndTo));
    }
    /** @dev set council address */
    function setCouncial(address _councilAddress) external nonReentrant onlyOperator {
        councilAddress = _councilAddress;
    }
    function setMinReplyHours(uint256 _hours) external nonReentrant onlyOperator {
        minReplyHours = _hours;
    }
    function updateDispute(address _disputeAddress) external nonReentrant onlyOperator {
        disputeAddress = _disputeAddress;
        dispute = DisputeInterface(_disputeAddress);
    }
    function updateVault(address _vaultAddress) public onlyOperator nonReentrant {
        vaultAddress = _vaultAddress;
        vault = VaultInterface(_vaultAddress);
    }
    function updateCouncil(address _councilAddress) public onlyOperator nonReentrant {
        councilAddress = _councilAddress;
    }
    function updateOperator(address _operator) public onlyOperator nonReentrant {
        operator = _operator;
    }
    function updateCompensationRate(uint256 _rate) external nonReentrant onlyOperator {
        compensationRate = _rate;
    }
    function getJudgementFee(uint256 _amount) internal view returns(uint256) {
        return _amount * councilJudgementFeeRate / 10000 + councilJudgementFee;        
    }
    function updateCouncilJudgementFee(uint256 _fee, uint256 _rate) external nonReentrant onlyOperator {
        councilJudgementFee = _fee;
        councilJudgementFeeRate = _rate;
    }
    function updateShaker(address _shakerAddress) external nonReentrant onlyOperator {
        shakerAddress = _shakerAddress;
    }
    function updateToken(address _tokenAddress) external nonReentrant onlyOperator {
        tokenAddress = _tokenAddress;
    }
}