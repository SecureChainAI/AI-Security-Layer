pragma solidity ^0.5.0;
import "../Oracles/Oracle.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/drafts/SignedSafeMath.sol";
import "@gnosis.pm/util-contracts/contracts/Proxy.sol";


contract UltimateOracleData {

    /*
     *  Events
     */
    event ForwardedOracleOutcomeAssignment(int outcome);
    event OutcomeChallenge(address indexed sender, int outcome);
    event OutcomeVote(address indexed sender, int outcome, uint amount);
    event Withdrawal(address indexed sender, uint amount);

    /*
     *  Storage
     */
    Oracle public forwardedOracle;
    ERC20 public collateralToken;
    uint8 public spreadMultiplier;
    uint public challengePeriod;
    uint public challengeAmount;
    uint public frontRunnerPeriod;

    int public forwardedOutcome;
    uint public forwardedOutcomeSetTimestamp;
    int public frontRunner;
    uint public frontRunnerSetTimestamp;

    uint public totalAmount;
    mapping (int => uint) public totalOutcomeAmounts;
    mapping (address => mapping (int => uint)) public outcomeAmounts;
}

contract UltimateOracleProxy is Proxy, UltimateOracleData {

    /// @dev Constructor sets ultimate oracle properties
    /// @param _forwardedOracle Oracle address
    /// @param _collateralToken Collateral token address
    /// @param _spreadMultiplier Defines the spread as a multiple of the money bet on other outcomes
    /// @param _challengePeriod Time to challenge oracle outcome
    /// @param _challengeAmount Amount to challenge the outcome
    /// @param _frontRunnerPeriod Time to overbid the front-runner
    constructor(
        address proxied,
        Oracle _forwardedOracle,
        ERC20 _collateralToken,
        uint8 _spreadMultiplier,
        uint _challengePeriod,
        uint _challengeAmount,
        uint _frontRunnerPeriod
    )
        Proxy(proxied)
        public
    {
        // Validate inputs
        require(   address(_forwardedOracle) != address(0)
                && address(_collateralToken) != address(0)
                && _spreadMultiplier >= 2
                && _challengePeriod > 0
                && _challengeAmount > 0
                && _frontRunnerPeriod > 0);
        forwardedOracle = _forwardedOracle;
        collateralToken = _collateralToken;
        spreadMultiplier = _spreadMultiplier;
        challengePeriod = _challengePeriod;
        challengeAmount = _challengeAmount;
        frontRunnerPeriod = _frontRunnerPeriod;
    }
}

/// @title Ultimate oracle contract - Allows to swap oracle result for ultimate oracle result
/// @author Stefan George - <stefan@gnosis.pm>
contract UltimateOracle is Proxied, Oracle, UltimateOracleData {
    using SignedSafeMath for int;
    using SafeMath for uint;

    /*
     *  Public functions
     */
    /// @dev Allows to set oracle outcome
    function setForwardedOutcome()
        public
    {
        // There was no challenge and the outcome was not set yet in the ultimate oracle but in the forwarded oracle
        require(   !isChallenged()
                && forwardedOutcomeSetTimestamp == 0
                && forwardedOracle.isOutcomeSet());
        forwardedOutcome = forwardedOracle.getOutcome();
        forwardedOutcomeSetTimestamp = now;
        emit ForwardedOracleOutcomeAssignment(forwardedOutcome);
    }

    /// @dev Allows to challenge the oracle outcome
    /// @param _outcome Outcome to bid on
    function challengeOutcome(int _outcome)
        public
    {
        // There was no challenge yet or the challenge period expired
        require(   !isChallenged()
                && !isChallengePeriodOver()
                && collateralToken.transferFrom(msg.sender, address(this), challengeAmount));
        outcomeAmounts[msg.sender][_outcome] = challengeAmount;
        totalOutcomeAmounts[_outcome] = challengeAmount;
        totalAmount = challengeAmount;
        frontRunner = _outcome;
        frontRunnerSetTimestamp = now;
        emit OutcomeChallenge(msg.sender, _outcome);
    }

    /// @dev Allows to challenge the oracle outcome
    /// @param _outcome Outcome to bid on
    /// @param amount Amount to bid
    function voteForOutcome(int _outcome, uint amount)
        public
    {
        uint maxAmount = (totalAmount - totalOutcomeAmounts[_outcome]).mul(spreadMultiplier);

        if (maxAmount > totalOutcomeAmounts[_outcome])
            maxAmount -= totalOutcomeAmounts[_outcome];
        else
            maxAmount = 0;

        if (amount > maxAmount)
            amount = maxAmount;
        // Outcome is challenged and front runner period is not over yet and tokens can be transferred
        require(   isChallenged()
                && !isFrontRunnerPeriodOver()
                && collateralToken.transferFrom(msg.sender, address(this), amount));
        outcomeAmounts[msg.sender][_outcome] = outcomeAmounts[msg.sender][_outcome].add(amount);
        totalOutcomeAmounts[_outcome] = totalOutcomeAmounts[_outcome].add(amount);
        totalAmount = totalAmount.add(amount);
        if (_outcome != frontRunner && totalOutcomeAmounts[_outcome] > totalOutcomeAmounts[frontRunner])
        {
            frontRunner = _outcome;
            frontRunnerSetTimestamp = now;
        }
        emit OutcomeVote(msg.sender, _outcome, amount);
    }

    /// @dev Withdraws winnings for user
    /// @return Winnings
    function withdraw()
        public
        returns (uint amount)
    {
        // Outcome was challenged and ultimate outcome decided
        require(isFrontRunnerPeriodOver());
        amount = totalAmount.mul(outcomeAmounts[msg.sender][frontRunner]) / totalOutcomeAmounts[frontRunner];
        outcomeAmounts[msg.sender][frontRunner] = 0;
        // Transfer earnings to contributor
        require(collateralToken.transfer(msg.sender, amount));
        emit Withdrawal(msg.sender, amount);
    }

    /// @dev Checks if time to challenge the outcome is over
    /// @return Is challenge period over?
    function isChallengePeriodOver()
        public
        view
        returns (bool)
    {
        return forwardedOutcomeSetTimestamp != 0 && now.sub(forwardedOutcomeSetTimestamp) > challengePeriod;
    }

    /// @dev Checks if time to overbid the front runner is over
    /// @return Is front runner period over?
    function isFrontRunnerPeriodOver()
        public
        view
        returns (bool)
    {
        return frontRunnerSetTimestamp != 0 && now.sub(frontRunnerSetTimestamp) > frontRunnerPeriod;
    }

    /// @dev Checks if outcome was challenged
    /// @return Is challenged?
    function isChallenged()
        public
        view
        returns (bool)
    {
        return frontRunnerSetTimestamp != 0;
    }

    /// @dev Returns if winning outcome is set
    /// @return Is outcome set?
    function isOutcomeSet()
        public
        view
        returns (bool)
    {
        return    isChallengePeriodOver() && !isChallenged()
               || isFrontRunnerPeriodOver();
    }

    /// @dev Returns winning outcome
    /// @return Outcome
    function getOutcome()
        public
        view
        returns (int)
    {
        if (isFrontRunnerPeriodOver())
            return frontRunner;
        return forwardedOutcome;
    }
}
