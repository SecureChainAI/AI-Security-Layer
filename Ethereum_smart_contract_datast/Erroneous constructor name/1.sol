pragma solidity ^0.4.8;

function DOXYCOIN() {
    balanceOf[msg.sender] = 110000000 * 100000000; // Give the creator all initial tokens
    totalSupply = 110000000 * 100000000; // Update total supply
    name = "DOXY COIN"; // Set the name for display purposes
    symbol = "DOXY"; // Set the symbol for display purposes
    decimals = 8; // Amount of decimals for display purposes
}
