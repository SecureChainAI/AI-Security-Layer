function kill() public ownerOnly {
    selfdestruct(owner);
}
