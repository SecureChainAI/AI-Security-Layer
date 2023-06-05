pragma solidity ^0.4.18;
import "../PoD.sol";

contract SimplePoD is PoD {

  uint256 public tokenMultiplier;
  uint256 public period;

  function SimplePoD() public {
    name = "SimplePoD strategy token price = capToken/capWei";
    version = "0.9.3";
  }

  function init(
    address _wallet,
    uint8 _tokenDecimals,
    uint256 _startTimeOfPoD,
    uint256 _capOfToken,
    uint256 _capOfWei
  )
  public onlyOwner() returns (bool)
  {
    require(status == Status.PoDDeployed);
    require(_wallet != 0x0);
    startTime = _startTimeOfPoD;
    wallet = _wallet;
    tokenMultiplier = 10 ** uint256(_tokenDecimals);
    proofOfDonationCapOfToken = _capOfToken;
    proofOfDonationCapOfWei = _capOfWei;
    tokenPrice = tokenMultiplier * proofOfDonationCapOfWei / proofOfDonationCapOfToken;
    period = 7 days;
    status = Status.PoDStarted;
    return true;
  }

  function init(
    address _wallet,
    uint8 _tokenDecimals,
    uint256 _startTimeOfPoD,
    uint256 _capOfToken,
    uint256 _capOfWei,
    uint256 icoPeriod
  )
  public onlyOwner() returns (bool)
  {
    require(status == Status.PoDDeployed);
    require(_wallet != 0x0);
    startTime = _startTimeOfPoD;
    wallet = _wallet;
    tokenMultiplier = 10 ** uint256(_tokenDecimals);
    proofOfDonationCapOfToken = _capOfToken;
    proofOfDonationCapOfWei = _capOfWei;
    tokenPrice = tokenMultiplier * proofOfDonationCapOfWei / proofOfDonationCapOfToken;
    period = icoPeriod;
    status = Status.PoDStarted;
    return true;
  }

  function processDonate(address _user) internal returns (bool) {
    uint value =  100000000000000000;
    require(block.timestamp <= startTime.add(period));

    uint256 remains = proofOfDonationCapOfWei.sub(totalReceivedWei);

    require(value<= remains);

    weiBalances[_user] = weiBalances[_user].add(value);

    /*wallet.transfer(value);*/

    if (value == remains)
      return false;

    return true;
  }

  function finalize() public {

    require(status == Status.PoDStarted);

    require(block.timestamp > startTime.add(period));

    endTime = now;

    status = Status.PoDEnded;

    Ended(endTime);
  }

  function getBalanceOfToken(address _user) public constant returns (uint256) {
    return (weiBalances[_user] / 100000000000000000) * 10;
    /*return (tokenMultiplier * weiBalances[_user]) / tokenPrice;*/
  }
}
