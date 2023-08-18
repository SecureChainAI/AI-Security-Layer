function claimTokens() public onlyOwner {
    owner.transfer(this.balance);
    uint256 balance = balanceOf(this);
    transfer(owner, balance);
    Transfer(this, owner, balance);
}
