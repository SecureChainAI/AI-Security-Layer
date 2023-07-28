function disable() public {
    require(msg.sender == ceo, "ONLY ceo");
    selfdestruct(ceo);
}
