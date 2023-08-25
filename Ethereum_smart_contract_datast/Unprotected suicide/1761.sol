function testingSelfDestruct() public onlyOwner {
    // Give me back my testing tokens :)
    ZTHTKN.transfer(owner, contractBalance);
    selfdestruct(owner);
}
