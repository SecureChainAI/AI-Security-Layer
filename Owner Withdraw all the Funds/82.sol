pragma solidity ^0.4.18;

function withdraw() public onlyOwner {
    address myAddress = this;
    uint256 etherBalance = myAddress.balance;
    owner.transfer(etherBalance);
}
