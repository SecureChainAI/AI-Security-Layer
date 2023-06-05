pragma solidity ^0.4.18;

function withdrawEther(uint256 amount) {
    if (msg.sender != owner) throw;
    owner.transfer(amount);
}
