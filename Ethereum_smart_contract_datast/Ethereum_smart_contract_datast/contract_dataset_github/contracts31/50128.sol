pragma solidity >=0.4.23 <0.6.0;

import "../interfaces/ERC20Interface.sol";
import "./TransferHelper.sol";
import "./SafeMath.sol";

contract TokenLocker {
  using SafeMath for uint256;
  using TransferHelper for *;

  event Released(address addr, uint256 amount, uint256 timestamp);
  event Revoked(address addr, uint256 amount, uint256 timestamp);

  address public operator;
  address public tokenManager;

  address public token;
  uint256 public cliff;
  uint256 public duration;

  struct VestToken{
      uint256 amount;   // Total amount
      uint256 start;    // Start from
  }
  mapping (address => VestToken[]) public vestToken;
  mapping (address => uint256) public vestTokenCount;
  mapping (address => uint256) public released;
  mapping (address => bool) public revoked;

  modifier onlyOperator {
    require(msg.sender == operator, "Only operator can call this function.");
    _;
  }

  modifier onlyTokenManager {
    require(msg.sender == tokenManager, "Only tokenManager contract can call this function.");
    _;
  }
    
  /**
   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
   * of the balance will have vested.
   * @param _token ERC20 token address
   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
   * @param _duration duration in seconds of the period in which the tokens will vest
   */
  constructor(
    address _token,
    uint256 _cliff,
    uint256 _duration
  ) public {
    require(_cliff <= _duration);

    token = _token;
    duration = _duration;
    cliff = _cliff;
    operator = msg.sender;
  }

  function setVestToken(address addr, uint256 amount) public onlyTokenManager {
      require(addr != address(0) && amount > 0);
      vestToken[addr].push(VestToken(amount, block.timestamp));
      vestTokenCount[addr] = vestTokenCount[addr].add(1);
  }

  function getVestToken(address addr) public view returns(uint256[] memory, uint256[] memory) {
      uint256[] memory amount = new uint256[](vestTokenCount[addr]);
      uint256[] memory start = new uint256[](vestTokenCount[addr]);
      for(uint256 i = 0; i < vestToken[addr].length; i++) {
          amount[i] = vestToken[addr][i].amount;
          start[i] = vestToken[addr][i].start;
      }
      return (amount, start);
  }

  /**
   * @notice Transfers vested tokens to beneficiary.
   */
  function release() public {
    address addr = msg.sender;
    require(!revoked[addr], 'This account is revoked');
    uint256 unreleased = releasableAmount(addr);
    require(unreleased > 0, "unreleased can not be zero");
    uint256 balance = ERC20Interface(token).balanceOf(address(this));
    require(balance >= unreleased, "Balance not enough");
    released[addr] = released[addr].add(unreleased);
    TransferHelper.safeTransfer(token, addr, unreleased);
    emit Released(addr, unreleased, block.timestamp);
  }

  /**
   * @notice Allows the owner to revoke the vesting. Tokens already vested
   * remain in the contract, the rest are returned to the owner.
   * @param addr User address
   */
  function revoke(address addr) public onlyOperator {
    require(revoked[addr], 'This account is not revokable');

    uint256 balance = ERC20Interface(token).balanceOf(address(this));
    released[addr] = released[addr].add(balance);
    TransferHelper.safeTransfer(token, operator, balance);
    emit Revoked(addr, balance, block.timestamp);
  }

  /**
   * @dev Calculates the amount that has already vested but hasn't been released yet.
   * @param addr User address
   */
  function releasableAmount(address addr) public view returns (uint256) {
    return vestedAmount(addr).sub(released[addr]);
  }

  /**
   * @dev Calculates the amount that has already vested.
   * @param addr User address
   */
  function vestedAmount(address addr) public view returns (uint256) {
    VestToken[] memory vests = vestToken[addr];
    uint256 total = 0;
    for(uint256 i = 0; i < vests.length; i++) {
      if (block.timestamp < vests[i].start.add(cliff)) {
          continue;
      } else if (block.timestamp >= vests[i].start.add(duration)) {
          total = total.add(vests[i].amount);
          continue;
      } else {
          uint256 d = vests[i].amount.div(duration).mul(block.timestamp.sub(vests[i].start.add(cliff)));
          total = total.add(d);
      }
    }
    return total;
  }
  
  function setRevoked(address addr, bool status) public onlyOperator {
      revoked[addr] = status;
  }
  function setCliff(uint256 _cliff) public onlyOperator {
    cliff = _cliff;
  }
  function setDuration(uint256 _duration) public onlyOperator {
    duration = _duration;
  }
  function setTokenAddress(address _tokenAddress) public onlyOperator {
    token = _tokenAddress;
  }
  function updateOperator(address _address) public onlyOperator {
    operator = _address;
  }
  function updateTokenManager(address _tokenManager) public onlyOperator {
    tokenManager = _tokenManager;
  }
}