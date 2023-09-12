function freeze(uint256 _value) public returns (bool success) {
    require(_value <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    freezes[msg.sender] = freezes[msg.sender].add(_value);
    emit Freeze(msg.sender, _value);
    return true;
}
