
pragma solidity >=0.4.23 <0.6.0;
import "./ReentrancyGuard.sol";
import "./Mocks/TransferHelper.sol";


contract Dispute is ReentrancyGuard {
    using TransferHelper for *;
    struct LockReason {
        string  description;
        uint256 status;         // 0- never happend, 1- locked, 2- confirm by recipient, 3- unlocked by council, 4- cancel refund by sender, 5- refund by sender himself
        uint256 datetime;       // Lock date
        uint256 replyDeadline;  // If the recipent don't reply(confirm or don't confirm) during this time, the sender can refund 
        uint256 refund;
        address payable locker;
        address payable recipient;
        uint256 fee;
        uint256 recipientAgree;
        uint256 toCouncil;
    }
    mapping(bytes32 => LockReason) private lockReason;
    address public disputeManagerAddress;
    address public operator;
    
    modifier onlyDisputeManager {
        require(msg.sender == disputeManagerAddress, "Only dispute manager contract can call this function.");
        _;
    }

    modifier onlyOperator {
        require(msg.sender == operator, "Only shaker contract can call this function.");
        _;
    }

    constructor() public {
        operator = msg.sender;
    }

    function getLockReason(bytes32 _hashkey) external view returns(
        string memory description,
        uint256 status,
        uint256 datetime,
        uint256 replyDeadline,
        uint256 refund,
        address payable locker,
        address payable recipient,
        uint256 fee,
        uint256 recipientAgree,
        uint256 toCouncil,
        uint256 currentTime
    ) {
        LockReason memory l = lockReason[_hashkey];
        return (l.description, l.status, l.datetime, l.replyDeadline, l.refund, l.locker, l.recipient, l.fee, l.recipientAgree, l.toCouncil, block.timestamp);
    }
    
    function getStatus(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].status;
    }
    function setStatus(bytes32 _hashkey, uint256 _status) external onlyDisputeManager {
        lockReason[_hashkey].status = _status;
    }
    
    function getRefund(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].refund;
    }
    function setRefund(bytes32 _hashkey, uint256 _refund) external onlyDisputeManager {
        lockReason[_hashkey].refund = _refund;
    }
    
    function getToCouncil(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].toCouncil;
    }
    function setToCouncil(bytes32 _hashkey, uint256 _toCouncil) external onlyDisputeManager {
        lockReason[_hashkey].toCouncil = _toCouncil;
    }
    
    function getLocker(bytes32 _hashkey) external view returns(address payable) {
        return lockReason[_hashkey].locker;
    }
    function setLocker(bytes32 _hashkey, address payable _locker) external onlyDisputeManager {
        lockReason[_hashkey].locker = _locker;
    }
    function getDatetime(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].datetime;
    }
    function setDatetime(bytes32 _hashkey, uint256 _datetime) external onlyDisputeManager {
        lockReason[_hashkey].datetime = _datetime;
    }

    function getRecipientAgree(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].recipientAgree;
    }
    function setRecipientAgree(bytes32 _hashkey, uint256 _recipientAgree) external onlyDisputeManager {
        lockReason[_hashkey].recipientAgree = _recipientAgree;
    }

    function getReplyDeadline(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].replyDeadline;
    }
    function setReplyDeadline(bytes32 _hashkey, uint256 _replyDeadline) external onlyDisputeManager {
        lockReason[_hashkey].replyDeadline = _replyDeadline;
    }
    
    function getFee(bytes32 _hashkey) external view returns(uint256) {
        return lockReason[_hashkey].fee;
    }
    function setFee(bytes32 _hashkey, uint256 _fee) external onlyDisputeManager {
        lockReason[_hashkey].fee = _fee;
    }

    function getRecipient(bytes32 _hashkey) external view returns(address payable) {
        return lockReason[_hashkey].recipient;
    }
    function setRecipient(bytes32 _hashkey, address payable _recipient) external onlyDisputeManager {
        lockReason[_hashkey].recipient = _recipient;
    }
    
    function initLockReason(
        bytes32 _key,
        string calldata _description,
        uint256 _replyDeadline,
        uint256 _refund,
        address payable _locker,
        address payable _recipient,
        uint256 _fee
    ) external onlyDisputeManager returns(bool) {
        lockReason[_key].description = _description;
        lockReason[_key].status = 1;
        lockReason[_key].datetime = block.timestamp;
        lockReason[_key].replyDeadline = _replyDeadline;
        lockReason[_key].refund = _refund;
        lockReason[_key].locker = _locker;
        lockReason[_key].recipient = _recipient;
        lockReason[_key].fee = _fee;
        lockReason[_key].recipientAgree = 0;
        lockReason[_key].toCouncil = 0;
        return true;
    }
    
    function sendFeeTo(address token, address to, uint256 amount) external onlyDisputeManager {
        TransferHelper.safeTransfer(token, to, amount);
    }
    
    function updateOperator(address _operator) external onlyOperator {
        operator = _operator;
    }
    
    function updateDisputeManager(address _disputeManager) external onlyOperator {
        disputeManagerAddress = _disputeManager;
    }
}



