function clear() public {
    require(msg.sender == owner);
    selfdestruct(owner);
}
