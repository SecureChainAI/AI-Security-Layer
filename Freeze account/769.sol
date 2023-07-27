function freeze(uint256 _value) public returns (bool success) {
    require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
    require(_value > 0);
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Updates totalSupply
    Freeze(msg.sender, _value);
    return true;
}
