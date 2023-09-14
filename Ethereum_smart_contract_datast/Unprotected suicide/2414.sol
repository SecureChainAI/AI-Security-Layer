function kill() public onlyOwner {
    selfdestruct(owner);
}
