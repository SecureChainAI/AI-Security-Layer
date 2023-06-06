pragma solidity ^0.4.18;

contract AbsPoD {
  function resetWeiBalance(address _user) public returns(bool);

  function getBalanceOfToken(address _user) public constant returns(uint256);

  function getCapOfToken() public constant returns(uint256);

  function isPoDStarted() public constant returns(bool);

  function isPoDEnded() public constant returns(bool);

  function getTokenPrice() public constant returns(uint256);

  function getStartTime() public constant returns (uint256);

  function getEndTime() public constant returns(uint256);

  function getTotalReceivedWei() public constant returns(uint256);

  function getCapOfWei() public constant returns(uint256);

  function getWallet() public constant returns (address);

  function donate() public constant returns (bool);
}
