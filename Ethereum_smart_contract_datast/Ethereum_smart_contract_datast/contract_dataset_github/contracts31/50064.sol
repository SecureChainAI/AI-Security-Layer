pragma solidity >=0.4.23 <0.6.0;

interface DisputeManagerInterface {
    function getStatus(bytes32 hashkey) external view returns(uint256);
    function lock(bytes32 _hashkey, uint256 _refund, string calldata _description, address payable _recipient, uint256 _replyHours) external;
    function unlockByRecipent(bytes32 _hashkey, bytes32 _commitment, uint8 _status) external;
    function unlockByCouncil(bytes32 _hashkey, uint8 _result) external;
}