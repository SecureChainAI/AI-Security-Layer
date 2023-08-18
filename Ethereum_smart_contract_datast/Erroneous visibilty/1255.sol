function burn(uint256 _value) returns (bool success) {
    if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
    if (_value <= 0) revert();
    balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value); // Subtract from the sender
    totalSupply = SafeMath.safeSub(totalSupply, _value); // Updates totalSupply
    Burn(msg.sender, _value);
    return true;
}

function freeze(uint256 _value) returns (bool success) {
    if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
    if (_value <= 0) revert();
    balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value); // Subtract from the sender
    freezes[msg.sender] = SafeMath.safeAdd(freezes[msg.sender], _value); // Updates totalSupply
    Freeze(msg.sender, _value);
    return true;
}

function unfreeze(uint256 _value) returns (bool success) {
    if (freezes[msg.sender] < _value) revert(); // Check if the sender has enough
    if (_value <= 0) revert();
    freezes[msg.sender] = SafeMath.safeSub(freezes[msg.sender], _value); // Subtract from the sender
    balances[msg.sender] = SafeMath.safeAdd(balances[msg.sender], _value);
    Unfreeze(msg.sender, _value);
    return true;
}
