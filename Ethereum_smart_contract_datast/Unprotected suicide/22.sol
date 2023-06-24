pragma solidity ^0.4.24;

function kill() public {
    require(msg.sender == admin);
    selfdestruct(admin);
}
