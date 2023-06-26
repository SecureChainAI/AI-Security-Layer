pragma solidity ^0.4.0;

contract simpleStorage{
    uint storedData;

    function set(uint x) public{
        storedData=x;
    }

    function get() constant public returns (uint){
        return storedData;
    }

    function increment(uint n) public {
        storedData=storedData+n;
        return;
    }

    function decrement(uint n) public {
        storedData=storedData-n;
        return;
    }
}
