pragma solidity >=0.4.23 <0.6.0;

interface VaultInterface {
    function setStatus(bytes32 _hashkey, uint256 _status) external;
    function setAmount(bytes32 _hashkey, uint256 _amount) external;
    function setSender(bytes32 _hashkey, address payable _sender) external;
    function setEffectiveTime(bytes32 _hashkey, uint256 _effectiveTime) external;
    function setTimestamp(bytes32 _hashkey, uint256 _timestamp) external;
    function setCanEndorse(bytes32 _hashkey, uint256 _canEndorse) external;
    function setLockable(bytes32 _hashkey, uint256 _lockable) external;
    function setParams1(bytes32 _hashkey, uint256 _params1) external;
    function setParams2(bytes32 _hashkey, uint256 _params2) external;
    function setParams3(bytes32 _hashkey, uint256 _params3) external;
    function setParams4(bytes32 _hashkey, address _params4) external;
    
    function getStatus(bytes32 _hashkey) external view returns(uint256);
    function getAmount(bytes32 _hashkey) external view returns(uint256);
    function getSender(bytes32 _hashkey) external view returns(address payable);
    function getEffectiveTime(bytes32 _hashkey) external view returns(uint256);
    function getTimestamp(bytes32 _hashkey) external view returns(uint256);
    function getCanEndorse(bytes32 _hashkey) external view returns(uint256);
    function getLockable(bytes32 _hashkey) external view returns(uint256);
    function getParams1(bytes32 _hashkey) external view returns(uint256);
    function getParams2(bytes32 _hashkey) external view returns(uint256);
    function getParams3(bytes32 _hashkey) external view returns(uint256);
    function getParams4(bytes32 _hashkey) external view returns(address);
    
    function addTotalAmount(uint256 _amount) external;
    function addTotalBalance(uint256 _amount) external;
    function sendDepositEvent(address _sender, bytes32 _hashkey, uint256 _amount, uint256 _timestamp) external;
    function sendWithdrawEvent(string calldata _commitment, uint256 _fee, uint256 _amount, uint256 _timestamp) external;
    function subTotalBalance(uint256 _amount) external;
    
}