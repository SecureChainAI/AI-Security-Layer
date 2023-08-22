function kill() public {
    if (msg.sender == owner) selfdestruct(owner);
}
