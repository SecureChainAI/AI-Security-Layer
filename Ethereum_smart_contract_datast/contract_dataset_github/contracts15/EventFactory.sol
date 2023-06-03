pragma solidity ^0.5.0;
import "../Events/CategoricalEvent.sol";
import "../Events/ScalarEvent.sol";


/// @title Event factory contract - Allows creation of categorical and scalar events
/// @author Stefan George - <stefan@gnosis.pm>
contract EventFactory {

    /*
     *  Events
     */
    event CategoricalEventCreation(address indexed creator, CategoricalEvent categoricalEvent, ERC20 collateralToken, Oracle oracle, uint8 outcomeCount);
    event ScalarEventCreation(address indexed creator, ScalarEvent scalarEvent, ERC20 collateralToken, Oracle oracle, int lowerBound, int upperBound);

    /*
     *  Storage
     */
    mapping (bytes32 => CategoricalEvent) public categoricalEvents;
    mapping (bytes32 => ScalarEvent) public scalarEvents;
    CategoricalEvent public categoricalEventMasterCopy;
    ScalarEvent public scalarEventMasterCopy;
    OutcomeToken public outcomeTokenMasterCopy;

    /*
     *  Public functions
     */
    constructor(
        CategoricalEvent _categoricalEventMasterCopy,
        ScalarEvent _scalarEventMasterCopy,
        OutcomeToken _outcomeTokenMasterCopy
    )
        public
    {
        categoricalEventMasterCopy = _categoricalEventMasterCopy;
        scalarEventMasterCopy = _scalarEventMasterCopy;
        outcomeTokenMasterCopy = _outcomeTokenMasterCopy;
    }

    /// @dev Creates a new categorical event and adds it to the event mapping
    /// @param collateralToken Tokens used as collateral in exchange for outcome tokens
    /// @param oracle Oracle contract used to resolve the event
    /// @param outcomeCount Number of event outcomes
    /// @return Event contract
    function createCategoricalEvent(
        ERC20 collateralToken,
        Oracle oracle,
        uint8 outcomeCount
    )
        public
        returns (CategoricalEvent eventContract)
    {
        bytes32 eventHash = keccak256(abi.encodePacked(collateralToken, oracle, outcomeCount));
        // Event should not exist yet
        require(address(categoricalEvents[eventHash]) == address(0));
        // Create event
        eventContract = CategoricalEvent(address(new CategoricalEventProxy(
            address(categoricalEventMasterCopy),
            address(outcomeTokenMasterCopy),
            collateralToken,
            oracle,
            outcomeCount
        )));
        categoricalEvents[eventHash] = eventContract;
        emit CategoricalEventCreation(msg.sender, eventContract, collateralToken, oracle, outcomeCount);
    }

    /// @dev Creates a new scalar event and adds it to the event mapping
    /// @param collateralToken Tokens used as collateral in exchange for outcome tokens
    /// @param oracle Oracle contract used to resolve the event
    /// @param lowerBound Lower bound for event outcome
    /// @param upperBound Lower bound for event outcome
    /// @return Event contract
    function createScalarEvent(
        ERC20 collateralToken,
        Oracle oracle,
        int lowerBound,
        int upperBound
    )
        public
        returns (ScalarEvent eventContract)
    {
        bytes32 eventHash = keccak256(abi.encodePacked(collateralToken, oracle, lowerBound, upperBound));
        // Event should not exist yet
        require(address(scalarEvents[eventHash]) == address(0));
        // Create event
        eventContract = ScalarEvent(address(new ScalarEventProxy(
            address(scalarEventMasterCopy),
            address(outcomeTokenMasterCopy),
            collateralToken,
            oracle,
            lowerBound,
            upperBound
        )));
        scalarEvents[eventHash] = eventContract;
        emit ScalarEventCreation(msg.sender, eventContract, collateralToken, oracle, lowerBound, upperBound);
    }
}
