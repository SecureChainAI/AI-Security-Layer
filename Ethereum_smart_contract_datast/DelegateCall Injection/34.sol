function destruct() public onlyOwner {
    selfdestruct(owner);
}
