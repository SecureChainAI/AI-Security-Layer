function test_suicide() public {
    require(msg.sender == owner);
    selfdestruct(msg.sender);
}
