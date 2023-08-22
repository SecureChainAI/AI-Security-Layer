function withdraw() public {
    uint256 etherBalance = this.balance;
    owner.transfer(etherBalance);
}
