function ownerkill() public onlyOwner {
    selfdestruct(owner);
}
