pragma solidity ^0.4.17;

contract USDCToken is Pausable, StandardToken, BlackList {
    function USDCToken() public {
        _totalSupply = 100000000; //_initialSupply;
        name = "USDC Token"; //_name;
        symbol = "USDC"; //_symbol;
        decimals = 6; //_decimals;
        balances[owner] = _totalSupply; //_initialSupply;
        deprecated = false;
    }
}
