pragma solidity ^0.4.24;

contract Owned {
    function Owned() public {
        owner = msg.sender;
    }
}

contract weR {
    function weR() public {
        symbol = "weR";
        name = "weR";
        decimals = 18;
        _totalSupply = 500000 * 10 ** uint(decimals);
        balances[owner] = _totalSupply;
        Transfer(address(0), owner, _totalSupply);
    }
}
