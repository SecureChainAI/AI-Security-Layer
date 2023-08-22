function withdraw() public onlyOwner returns (bool result) {
    return owner.send(this.balance);
}
