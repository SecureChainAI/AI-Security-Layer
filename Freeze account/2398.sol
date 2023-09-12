function freeze(uint256 _value) public returns (bool success) {
    if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough
    if (_value <= 0) revert();
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Updates totalSupply
    emit Freeze(msg.sender, _value);
    return true;
}
