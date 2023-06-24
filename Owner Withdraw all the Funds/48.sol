pragma solidity ^0.4.22;

function withdraw() public onlyOwner {
    uint256 etherBalance = address(this).balance;
    owner.transfer(etherBalance);
}
