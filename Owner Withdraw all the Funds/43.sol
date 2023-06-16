pragma solidity ^0.4.11;

function close() public {
    if (msg.sender == fiduciary) {
        msg.sender.transfer(this.balance);
    }
}
