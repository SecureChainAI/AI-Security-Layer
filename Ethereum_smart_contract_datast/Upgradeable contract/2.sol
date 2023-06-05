pragma solidity ^0.4.17;

contract UpgradedStandardToken is StandardToken {
    // those methods are called by the legacy contract
    // and they must ensure msg.sender to be the contract address
    function transferByLegacy(address from, address to, uint value) public;

    function transferFromByLegacy(
        address sender,
        address from,
        address spender,
        uint value
    ) public;

    function approveByLegacy(address from, address spender, uint value) public;
}
