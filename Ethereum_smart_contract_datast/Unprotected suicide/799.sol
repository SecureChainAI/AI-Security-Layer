function destruct() public {
    if (owner == msg.sender) {
        selfdestruct(owner);
    }
}
