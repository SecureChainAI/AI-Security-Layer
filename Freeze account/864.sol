function freeze(uint256 _value) returns (bool success) {
    if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
    if (_value <= 0) revert();
    balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value); // Subtract from the sender
    freezes[msg.sender] = SafeMath.safeAdd(freezes[msg.sender], _value); // Updates totalSupply
    Freeze(msg.sender, _value);
    return true;
}
