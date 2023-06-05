pragma solidity ^0.4.0;

contract owned {
    address owner;

    modifier onlyowner() {
        if (msg.sender == owner) {
            _;
        }
    }

    function owned() {
        owner = msg.sender;
    }
}
contract Mortal is owned {
    function kill() {
        if (msg.sender == owner)
            selfdestruct(owner);
    }
}
