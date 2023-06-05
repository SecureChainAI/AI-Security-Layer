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

import "./interfaces/RedpacketVaultInterface.sol";
import "./interfaces/ERC20Interface.sol";
import "./interfaces/ShakerTokenManagerInterface.sol";

import "./ReentrancyGuard.sol";
import "./Mocks/SafeMath.sol";
import "./Mocks/TransferHelper.sol";

contract RedPacket is ReentrancyGuard {
    using TransferHelper for *;
    using SafeMath for uint256;

    address public operator;
    address public tokenAddress;        // USDT token
    address public redpacketVaultAddress;
    address public redpacketVaultV2Address;
    address public tokenManager;
    uint256 public feeRate = 50;        // 50 means 0.5%
    address public commonWithdrawAddress; 
    uint256 public maxAmount = 50;      // max amount of each redpacket
    uint256 public exchangeRate = 1e8;
    mapping(bytes32 => mapping(address => uint256)) redpacketTaken;

    constructor (
        address _redpacketVaultAddress,
        address _redpacketVaultV2Address,
        address _tokenAddress,
        address _commonWithdrawAddress
    ) public {
        operator = msg.sender;
        redpacketVaultAddress = _redpacketVaultAddress;
        redpacketVaultV2Address = _redpacketVaultV2Address;
        tokenAddress = _tokenAddress;
        commonWithdrawAddress = _commonWithdrawAddress;
    }

    modifier onlyOperator {
        require(msg.sender == operator, "Only operator can call this function.");
        _;
    }
    
    // Version 1: all deposit and withdraw data is published by event, everyone can search, and high rish. 
    // Version 2: data is save in a vault, only sender can search his redpackets, low risk.
    function deposit (
        bytes32 _hashKey,
        uint256 _amount,
        uint256 _cliff,
        string calldata _memo,
        uint256 _version
    ) external nonReentrant {
        RedpacketVaultInterface vault = _version == 1 ? RedpacketVaultInterface(redpacketVaultAddress) : RedpacketVaultInterface(redpacketVaultV2Address);
        require(_amount <= maxAmount, 'exceed max amount of each redpacket');
        require(vault.getStatus(_hashKey) == 0, "The commitment has been submitted or used out.");
        require(_amount > 0);
        
        uint256 allowance = ERC20Interface(tokenAddress).allowance(msg.sender, address(this));
        require(allowance >= _amount, "allowance of redpacket manager to sender is not enough");
        address vaultAddress = _version == 1 ? redpacketVaultAddress : redpacketVaultV2Address;
        TransferHelper.safeTransferFrom(tokenAddress, msg.sender, vaultAddress, _amount);
        
        vault.setStatus(_hashKey, 1);
        vault.setAmount(_hashKey, _amount);
        vault.setSender(_hashKey, msg.sender);
        vault.setTimestamp(_hashKey, block.timestamp);
        vault.setCliff(_hashKey, _cliff);
        vault.setMemo(_hashKey, _memo);
        vault.initTakenAddresses(_hashKey);

        vault.addTotalAmount(_amount);
        vault.addTotalBalance(_amount);
        
        if(_version == 1) vault.sendRedpacketDepositEvent(msg.sender, _hashKey, _amount, block.timestamp);
    }
    
    function withdraw (bytes32 _hashkey, uint256 _version) external nonReentrant {
        require(redpacketTaken[_hashkey][msg.sender] == 0, "Has taken this redpacket");
        RedpacketVaultInterface vault = _version == 1 ? RedpacketVaultInterface(redpacketVaultAddress) : RedpacketVaultInterface(redpacketVaultV2Address);
        address vaultAddress = _version == 1 ? redpacketVaultAddress : redpacketVaultV2Address;
        
        require(vault.getAmount(_hashkey) > 0, 'The commitment of this recipient is not exist or used out');
        require(!vault.isTaken(_hashkey, msg.sender), 'this address has taken red packet');
        (,uint256 amount,,,) = this.getAmount(_hashkey, _version);
        require(amount > 0, "redpacket amount is zero");
        uint256 refundAmount = amount < vault.getAmount(_hashkey) ? amount : vault.getAmount(_hashkey); //Take all if _refund == 0
        require(refundAmount > 0, "Refund amount can not be zero");
    
        uint256 allowance = ERC20Interface(tokenAddress).allowance(vaultAddress, address(this));
        require(allowance >= refundAmount, "allowance of redpacket manager to vault is not enough");
    
        vault.setAmount(_hashkey, vault.getAmount(_hashkey).sub(refundAmount));
        vault.setStatus(_hashkey, vault.getAmount(_hashkey) <= 0 ? 0 : 1);
        vault.setWithdrawTimes(_hashkey, vault.getWithdrawTimes(_hashkey).add(1));
        vault.subTotalBalance(refundAmount);
        redpacketTaken[_hashkey][msg.sender] = 1;

        uint256 _fee = refundAmount.mul(feeRate).div(10000);
        require(_fee <= refundAmount, "The fee can not be more than refund amount");

        TransferHelper.safeTransferFrom(tokenAddress, vaultAddress, commonWithdrawAddress, _fee);
        TransferHelper.safeTransferFrom(tokenAddress, vaultAddress, msg.sender, refundAmount.sub(_fee));

        uint256 _hours = (block.timestamp.sub(vault.getTimestamp(_hashkey))).div(3600);
        address _sender = vault.getSender(_hashkey);
        sendBonus(refundAmount, _hours, _sender);

        if(_version == 1) vault.sendRedpacketWithdrawEvent(vault.getSender(_hashkey), msg.sender, _hashkey, refundAmount.sub(_fee), block.timestamp);
    }
    
    function sendBonus(uint256 _refundAmount, uint256 _hours, address _sender) internal {
        uint256 decimals = ERC20Interface(tokenAddress).decimals();
        ShakerTokenManagerInterface(tokenManager).sendRedpacketBonus(_refundAmount.mul(exchangeRate).div(1e8), decimals, _hours, _sender);
    }

    function revoke (bytes32 _hashkey, uint256 _version) external nonReentrant {
        RedpacketVaultInterface vault = _version == 1 ? RedpacketVaultInterface(redpacketVaultAddress) : RedpacketVaultInterface(redpacketVaultV2Address);
        require(msg.sender == vault.getSender(_hashkey), 'The revoke must be operated by sender');
        uint256 amount = vault.getAmount(_hashkey);
        require(amount > 0, 'The commitment of this recipient is not exist or used out');

        address vaultAddress = _version == 1 ? redpacketVaultAddress : redpacketVaultV2Address;
        uint256 allowance = ERC20Interface(tokenAddress).allowance(vaultAddress, address(this));
        require(allowance >= amount, "allowance of redpacket manager to vault is not enough");
        TransferHelper.safeTransferFrom(tokenAddress, vaultAddress, msg.sender, amount);
    
        vault.setAmount(_hashkey, 0);
        vault.setStatus(_hashkey, 0);
        vault.subTotalBalance(amount);
    }
    
    function isTaken(bytes32 _hashkey) external view returns(uint256) {
        return redpacketTaken[_hashkey][msg.sender];
    }
    
    function getAmount(bytes32 _hashkey, uint256 _version) external view returns(uint256, uint256, uint256, uint256, string memory) {
        RedpacketVaultInterface vault = _version == 1 ? RedpacketVaultInterface(redpacketVaultAddress) : RedpacketVaultInterface(redpacketVaultV2Address);
        // require(msg.sender == vault.getSender(_hashkey), "only sender can call this function");
        uint256 balance = vault.getAmount(_hashkey);
        uint256 times = vault.getWithdrawTimes(_hashkey);
        uint256 cliff = vault.getCliff(_hashkey);
        string memory memo = vault.getMemo(_hashkey);
        if(balance == 0) return (0, 0, times, cliff, memo);
        else return(balance, cal(balance, cliff), times, cliff, memo);
    }

    function getMoreDetails(bytes32 _hashkey, uint256 _version) external view returns(uint256, uint256, address) {
        RedpacketVaultInterface vault = _version == 1 ? RedpacketVaultInterface(redpacketVaultAddress) : RedpacketVaultInterface(redpacketVaultV2Address);
        // require(msg.sender == vault.getSender(_hashkey), "only sender can call this function");
        uint256 amount = vault.getAmount(_hashkey);
        uint256 timestamp = vault.getTimestamp(_hashkey);
        address sender = vault.getSender(_hashkey);
        return(amount, timestamp, sender);
    }
    
    function cal(uint256 balance, uint256 cliff) internal pure returns(uint256) {
        return balance.mul(cliff).div(100);
    }
    
    function updateTokenAddress(address _tokenAddress) external nonReentrant onlyOperator {
        tokenAddress = _tokenAddress;
    }
    
    function updateRedpacketVaultAddress(address _vaultAddress) external nonReentrant onlyOperator {
        redpacketVaultAddress = _vaultAddress;
    }
    
    function updateRedpacketVaultV2Address(address _vaultAddress) external nonReentrant onlyOperator {
        redpacketVaultV2Address = _vaultAddress;
    }

    function updateTokenManager(address _tokenManager) external nonReentrant onlyOperator {
        tokenManager = _tokenManager;
    }
    
    function updateFeeRate(uint256 _rate) external nonReentrant onlyOperator {
        feeRate = _rate;
    }
    
    function updateCommonWithdrawAddress(address _addr) external nonReentrant onlyOperator {
        commonWithdrawAddress = _addr;
    }
    
    function updateMaxAmount(uint256 _amount) external nonReentrant onlyOperator {
        maxAmount = _amount;
    }
    function updateExchangeRate(uint256 _rate) external nonReentrant onlyOperator {
        exchangeRate = _rate;
    }

}