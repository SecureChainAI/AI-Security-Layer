pragma solidity 0.4.24;

contract LingYanToken {
    function LingYanToken() {
        balances[msg.sender] = totalSupply;
        Transfer(address(0), msg.sender, totalSupply);
    }
}
