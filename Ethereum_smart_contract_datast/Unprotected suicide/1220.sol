function selfdestructs() public payable onlyOwner {
    selfdestruct(owner);
}
