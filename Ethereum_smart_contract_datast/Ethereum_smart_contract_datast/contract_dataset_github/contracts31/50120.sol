pragma solidity >=0.4.23 <0.6.0;

interface RedpacketVaultInterface {
    function setStatus(bytes32 _hashkey, uint256 _status) external;
    function setAmount(bytes32 _hashkey, uint256 _amount) external;
    function setSender(bytes32 _hashkey, address payable _sender) external;
    function setTimestamp(bytes32 _hashkey, uint256 _timestamp) external;
    function setMemo(bytes32 _hashkey, string calldata _mem) external;
    function setWithdrawTimes(bytes32 _hashkey, uint256 _times) external;
    function setCliff(bytes32 _hashkey, uint256 _cliff) external;
    
    function initTakenAddresses(bytes32 _hashkey) external;
    function addTakenAddress(bytes32 _hashkey, address _address) external;
    
    function isTaken(bytes32 _hashkey, address _address) external view returns(bool);
    
    function getStatus(bytes32 _hashkey) external view returns(uint256);
    function getAmount(bytes32 _hashkey) external view returns(uint256);
    function getSender(bytes32 _hashkey) external view returns(address payable);
    function getTimestamp(bytes32 _hashkey) external view returns(uint256);
    function getMemo(bytes32 _hashkey) external view returns(string memory);
    function getWithdrawTimes(bytes32 _hashkey) external view returns(uint256);
    function getCliff(bytes32 _hashkey) external view returns(uint256);

    function addTotalAmount(uint256 _amount) external;
    function addTotalBalance(uint256 _amount) external;
    
    function sendRedpacketDepositEvent(address _sender, bytes32 _hashkey, uint256 _amount, uint256 _timestamp) external;
    function sendRedpacketWithdrawEvent(address sender, address recipient, bytes32 hashKey, uint256 _amount, uint256 _timestamp) external;
    function subTotalBalance(uint256 _amount) external;
    
}