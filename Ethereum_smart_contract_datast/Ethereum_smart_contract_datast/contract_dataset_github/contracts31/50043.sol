pragma solidity ^0.4.25;

contract AccessControl {
    address public ceoAddress; // contract's owner and manager address

    bool public paused = false; // keeps track of whether or not contract is paused

    /**
    @notice fired when a new address is set as CEO
    */
    event CEOSet(address newCEO);
    
    /**
    @notice fired when the contract is paused
     */
    event Paused();
    
    /**
    @notice fired when the contract is unpaused
     */
    event Unpaused();

    // AccessControl constructor - sets default executive roles of contract to the sender account
    constructor() public {
        ceoAddress = msg.sender;
        emit CEOSet(ceoAddress);
    }

    // access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    // assigns new CEO address - only available to the current CEO
    function setCEO(address _newCEO) public onlyCEO {
        require(_newCEO != address(0));
        ceoAddress = _newCEO;
        emit CEOSet(ceoAddress);
    }

    // modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    // modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    // pauses the smart contract - can only be called by the CEO
    function pause() public onlyCEO whenNotPaused {
        paused = true;
        emit Paused();
    }

    // unpauses the smart contract - can only be called by the CEO
    function unpause() public onlyCEO whenPaused {
        paused = false;
        emit Unpaused();
    }
}
