pragma solidity ^0.5.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./ReentrancyGuard.sol";
import "./DSLibrary/DSAuth.sol";
import "./DSLibrary/DSMath.sol";

interface CErc20 {
    function balanceOf(address _owner) external view returns (uint);
    //function balanceOfUnderlying(address owner) external returns (uint);
    function balanceOfUnderlying(address owner) external view returns (uint);
    function mint(uint mintAmount) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function redeem(uint redeemAmount) external returns (uint);
    function exchangeRateStored() external view returns (uint);
}

contract Staker is DSAuth, ReentrancyGuard {
    using DSMath for uint256;
    using SafeERC20 for IERC20;

    uint256 constant TOUCHDECIMAL = 8;
    uint256 constant STABLEDECIMAL = 6;
    uint256 constant MAXIMUMDEPOSIT = 100000 * (10 ** STABLEDECIMAL);
    uint256 public minimalDeposit = 500 * (10 ** STABLEDECIMAL);

    address public touchToken;
    address public stableCoin;
    address public compound;
    uint256 public touchPrice; // offset 10 ** 6
    uint256 public principle;

    struct DepositInfo {
        uint256 amount;
        uint256 startTime;
        uint256 period;
    }

    struct Account {
        uint256 referredCount;
        uint256 referredAmount;
        uint256 referredMilestoneAchived;
        uint256 rewards;
    }

    mapping (address => mapping (uint256 => DepositInfo)) public deposits;
    mapping (address => uint256) public userDepositsCounts;
    mapping (address => uint256) public userTotalDeposited;
    mapping (address => Account) public accounts;

    event UserDeposit(address indexed sender, uint256 value, uint256 timestamp, uint256 matureDate, uint256 touchAmount, uint256 depositId);
    event UserWithdraw(address indexed sender, uint256 depositAmount, uint256 value, uint256 withdrawId, uint256 timestamp);
    event ClaimReferral(address indexed sender, uint256 touchAmount, uint256 timestamp);

    constructor(address _touch, address _stable, address _compound) public {
        touchToken = _touch;
        stableCoin = _stable;
        compound = _compound;
        IERC20(_stable).safeApprove(_compound, uint256(-1));
        touchPrice = 10 ** STABLEDECIMAL;
    }

    function deposit(uint256 _amount, uint256 _period, address _referrer) external nonReentrant auth {
        require(_amount >= minimalDeposit, "the supplied amount should more than minimal deposit.");
        require(_period > 0 && _period < 4, "the period should between 1 to 3 months. ");
        require(getUserCurrentDepositAmount(msg.sender).add(_amount) <= MAXIMUMDEPOSIT, "deposit too more per user.");

        getFromUser(_amount);
        userDepositsCounts[msg.sender] += 1;
        userTotalDeposited[msg.sender] = userTotalDeposited[msg.sender].add(_amount);
        deposits[msg.sender][userDepositsCounts[msg.sender]] = DepositInfo(_amount, getTime(), _period);
        principle = principle.add(_amount);

        uint256 referredBonus = 0;

        // update referral info
        if (userDepositsCounts[_referrer] != 0 && _referrer != msg.sender) {
            Account memory _referrerAccount = accounts[_referrer];
            (_referrerAccount, referredBonus) = _updateCountReward(_referrerAccount);
            _referrerAccount = _updateMilestoneReward(_referrerAccount, _amount);
            accounts[_referrer] = _referrerAccount;
        }

        // check interest in stable coin
        uint256 _equaledUSD = calInterest(_amount, _period);
        uint256 _touchToUser = _equaledUSD.mul(10 ** TOUCHDECIMAL).div(touchPrice);
        IERC20(touchToken).safeTransfer(msg.sender, _touchToUser.add(referredBonus));

        emit UserDeposit(
            msg.sender,
            _amount,
            getTime(),
            getTime() + _period * 30 days,
            _touchToUser.add(referredBonus),
            userDepositsCounts[msg.sender]);
    }

    function withdraw(address _user, uint256 _withdrawId) external nonReentrant {
        DepositInfo memory depositInfo = deposits[_user][_withdrawId];
        require(depositInfo.amount > 0, "the deposit has already withdrawed or not exist");
        require(getTime() >= depositInfo.startTime.add(1 days), "must deposit more than 1 days");
        require(
            getTime() >= depositInfo.startTime.add(depositInfo.period.mul(30 days)) ||
            _user == msg.sender, "the stake is not ended, must withdraw by owner");
        uint256 depositAmount = depositInfo.amount;
        principle = principle.sub(depositInfo.amount);
        uint256 shouldPayToUser = calRealInterest(_user, _withdrawId);
        depositInfo.amount = 0;
        deposits[_user][_withdrawId] = depositInfo;
        sendToUser(_user, shouldPayToUser);
        emit UserWithdraw(_user, depositAmount, shouldPayToUser, _withdrawId, getTime());
    }

    function claimReferalReward(address _user) external nonReentrant {
        Account memory _account = accounts[_user];
        require(_account.rewards != 0, "user has no rewards");
        uint256 _amount = _account.rewards;
        _account.rewards = 0;
        accounts[_user] = _account;
        IERC20(touchToken).safeTransfer(_user, _amount);
        emit ClaimReferral(_user, _amount, getTime());
    }

    // getter function
    function tokenBalance() public view returns (uint256) {
        uint256 balanceInDefi = CErc20(compound).balanceOf(address(this));
        balanceInDefi = balanceInDefi.mul(CErc20(compound).exchangeRateStored()).div(1e18);
        uint256 contractBalance = IERC20(stableCoin).balanceOf(address(this));
        return balanceInDefi.add(contractBalance);
    }

    function getProfit() public view returns (uint256) {
        uint256 _tokenBalance = tokenBalance();
        return _tokenBalance.sub(principle);
    }

    function getTime() public view returns (uint256) {
        return block.timestamp;
    }

    function getTouchPrice() public view returns (uint256) {
        return touchPrice;
    }

    function getWithdrawAmountEstimate(address _user, uint256 _withdrawId) public view returns (uint256) {
        return calRealInterest(_user, _withdrawId);
    }

    function getInterestEstimate(uint256 _amount, uint256 _period) public pure returns (uint256) {
        return calInterest(_amount, _period);
    }

    function getUserCurrentDepositAmount(address _user) public view returns (uint256) {
        uint256 depositsCounts = userDepositsCounts[_user];
        if(depositsCounts == 0) {
            return 0;
        }
        uint256 sum = 0;
        for(uint256 i = 1; i <= depositsCounts; i++) {
            sum = sum.add(deposits[_user][i].amount);
        }
        return sum;
    }

    // admin
    function setTouchPrice(uint256 _price) external auth {
        touchPrice = _price;
    }

    function setMinimalDeposit(uint256 _minimalDeposit) external auth {
        minimalDeposit = _minimalDeposit;
    }

    // owner
    function withdrawProfit() external onlyOwner {
        uint256 _profit = getProfit();
        require(CErc20(compound).redeemUnderlying(_profit) == 0, "compound error");
        IERC20(stableCoin).safeTransfer(msg.sender, _profit);
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 amount = IERC20(compound).balanceOf(address(this));
        require(CErc20(compound).redeem(amount) == 0, "compound error");
        IERC20(stableCoin).safeTransfer(msg.sender, IERC20(stableCoin).balanceOf(address(this)));
    }

    function withdrawContractToken(address _token) external onlyOwner {
        // allow owner to withdraw token in contract,
        // can not withdraw cUSDT
        require(_token != address(compound), "owner can not transfer the cToken");
        uint256 balance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(msg.sender, balance);
    }

    // internal
    function calInterest(uint256 _amount, uint256 _period) internal pure returns (uint256) {
        if(_period == 3) { // 3 months, APR = 10%
            //return _amount * 10 / 100 / 4;
            return _amount.mul(10).div(400);
        } else if (_period == 2) { // 2 month, APR = 8 %
            //return _amount * 8 / 100 / 6;
            return _amount.mul(8).div(600);
        } else if (_period == 1) { // 1 month, APR = 6 %
            //return _amount * 6 / 100 / 12;
            return _amount.mul(6).div(1200);
        }
        return 0;
    }

    function calRealInterest(address _user, uint256 _withdrawId) internal view returns (uint256) {
        DepositInfo memory depositInfo = deposits[_user][_withdrawId];
        if (depositInfo.amount == 0) {
            return 0;
        }
        if (getTime() >= depositInfo.startTime.add(depositInfo.period.mul(30 days))) {
            return depositInfo.amount;
        } else {
            //require(_user == msg.sender, "the stake is not ended, must withdraw by owner");
            uint256 shouldCalculatedDays = getTime().sub(depositInfo.startTime).div(1 days);
            // APR 2.9% --> daily 0.00794521%
            uint256 _instrest = depositInfo.amount.mul(794521).mul(shouldCalculatedDays).div(10 ** 10);
            uint256 shouldRepayToUser = depositInfo.amount.add(_instrest).sub(calInterest(depositInfo.amount, depositInfo.period));
            return shouldRepayToUser;
        }
    }

    function _updateCountReward(Account memory _account) internal view returns (Account memory, uint256) {
        Account memory __account = _account;
        uint256 referredBonus = 0;
        if (userDepositsCounts[msg.sender] == 1) {
            __account.referredCount += 1;
            referredBonus = referredBonus.add(50 * (10 ** TOUCHDECIMAL));
            __account.rewards = __account.rewards.add((_account.referredCount / 10 * 10 + 50).mul(10 ** TOUCHDECIMAL));
        }
        return (__account, referredBonus);
    }

    function _updateMilestoneReward(Account memory _account, uint256 _amount) internal pure returns (Account memory) {
        _account.referredAmount += _amount;
        while(_account.referredAmount >= _account.referredMilestoneAchived.add(10000 * (10 ** STABLEDECIMAL))) {
            _account.referredMilestoneAchived += 10000 * (10 ** STABLEDECIMAL);
            _account.rewards += ((_account.referredMilestoneAchived.div((10000 * (10 ** STABLEDECIMAL)))).mul(200).add(800)).mul(10 ** TOUCHDECIMAL);
        }
        return _account;
    }

    function sendToUser(address _user, uint256 _amount) internal {
        require(CErc20(compound).redeemUnderlying(_amount) == 0, "compound error");
        IERC20(stableCoin).safeTransfer(_user, _amount);
    }

    function getFromUser(uint256 _amount) internal    {
        IERC20(stableCoin).safeTransferFrom(msg.sender, address(this), _amount);
        require(CErc20(compound).mint(_amount) == 0, "compound error");
    }
}
