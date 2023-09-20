function ownerkill() public onlyOwner {
    ZTHTKN.transfer(owner, contractBalance);
    selfdestruct(owner);
}
