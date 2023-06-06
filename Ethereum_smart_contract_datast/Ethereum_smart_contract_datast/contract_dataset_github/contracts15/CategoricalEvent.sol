pragma solidity ^0.5.0;
import "../Events/Event.sol";
import "@gnosis.pm/util-contracts/contracts/Proxy.sol";


contract CategoricalEventProxy is Proxy, EventData {

    /// @dev Contract constructor validates and sets basic event properties
    /// @param _collateralToken Tokens used as collateral in exchange for outcome tokens
    /// @param _oracle Oracle contract used to resolve the event
    /// @param outcomeCount Number of event outcomes
    constructor(address proxied, address outcomeTokenMasterCopy, ERC20 _collateralToken, Oracle _oracle, uint8 outcomeCount)
        Proxy(proxied)
        public
    {
        // Validate input
        require(address(_collateralToken) != address(0) && address(_oracle) != address(0) && outcomeCount >= 2);
        collateralToken = _collateralToken;
        oracle = _oracle;
        // Create an outcome token for each outcome
        for (uint8 i = 0; i < outcomeCount; i++) {
            OutcomeToken outcomeToken = OutcomeToken(address(new OutcomeTokenProxy(outcomeTokenMasterCopy)));
            outcomeTokens.push(outcomeToken);
            emit OutcomeTokenCreation(outcomeToken, i);
        }
    }
}

/// @title Categorical event contract - Categorical events resolve to an outcome from a set of outcomes
/// @author Stefan George - <stefan@gnosis.pm>
contract CategoricalEvent is Proxied, Event {

    /*
     *  Public functions
     */
    /// @dev Exchanges sender's winning outcome tokens for collateral tokens
    /// @return Sender's winnings
    function redeemWinnings()
        public
        returns (uint winnings)
    {
        // Winning outcome has to be set
        require(isOutcomeSet);
        // Calculate winnings
        winnings = outcomeTokens[uint(outcome)].balanceOf(msg.sender);
        // Revoke tokens from winning outcome
        outcomeTokens[uint(outcome)].revoke(msg.sender, winnings);
        // Payout winnings
        require(collateralToken.transfer(msg.sender, winnings));
        emit WinningsRedemption(msg.sender, winnings);
    }

    /// @dev Calculates and returns event hash
    /// @return Event hash
    function getEventHash()
        public
        view
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(collateralToken, oracle, outcomeTokens.length));
    }
}
