function YOPT(
    uint256 initialSupply,
    string tokenName,
    uint8 decimalUnits,
    string tokenSymbol
) {
    totalSupply = initialSupply * 10 ** uint256(decimalUnits); // Update total supply
    balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
    name = tokenName; // Set the name for display purposes
    symbol = tokenSymbol; // Set the symbol for display purposes
    decimals = decimalUnits; // Amount of decimals for display purposes
    owner = msg.sender;
}

function transfer(address _to, uint256 _value) {
    if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
    if (_value <= 0) throw;
    if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
    Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
}

/* Allow another contract to spend some tokens in your behalf */
function approve(address _spender, uint256 _value) returns (bool success) {
    if (_value <= 0) throw;
    allowance[msg.sender][_spender] = _value;
    return true;
}

/* A contract attempts to get the coins */
function transferFrom(
    address _from,
    address _to,
    uint256 _value
) returns (bool success) {
    if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
    if (_value <= 0) throw;
    if (balanceOf[_from] < _value) throw; // Check if the sender has enough
    if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
    if (_value > allowance[_from][msg.sender]) throw; // Check allowance
    balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); // Subtract from the sender
    balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
    allowance[_from][msg.sender] = SafeMath.safeSub(
        allowance[_from][msg.sender],
        _value
    );
    Transfer(_from, _to, _value);
    return true;
}

function burn(uint256 _value) returns (bool success) {
    if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (_value <= 0) throw;
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    totalSupply = SafeMath.safeSub(totalSupply, _value); // Updates totalSupply
    Burn(msg.sender, _value);
    return true;
}
