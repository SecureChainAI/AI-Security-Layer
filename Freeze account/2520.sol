function freeze(uint256 _value) public returns (bool success) {
    if (balanceOf[msg.sender] < _value) revert();
    if (_value <= 0) revert();
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
    freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
    emit Freeze(msg.sender, _value);
    return true;
}
