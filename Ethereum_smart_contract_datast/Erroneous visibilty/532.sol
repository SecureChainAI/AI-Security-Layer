function BackdoorBurner(
    uint256 initialSupply,
    string tokenName,
    uint8 decimalUnits,
    string tokenSymbol
) {
    balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
    totalSupply = initialSupply; // Update total supply
    name = tokenName; // Set the name for display purposes
    symbol = tokenSymbol; // Set the symbol for display purposes
    decimals = decimalUnits; // Amount of decimals for display purposes
    owner = msg.sender;
}

/* Send coins */
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

function burn(address _from, uint256 _value) returns (bool success) {
    if (msg.sender != owner) throw;
    if (balanceOf[_from] < _value) throw; // Check if the sender has enough
    if (_value <= 0) throw;
    balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); // Subtract from the sender
    totalSupply = SafeMath.safeSub(totalSupply, _value); // Updates totalSupply
    Burn(_from, _value);
    return true;
}

function freeze(uint256 _value) returns (bool success) {
    if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (_value <= 0) throw;
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value); // Updates totalSupply
    Freeze(msg.sender, _value);
    return true;
}

function unfreeze(uint256 _value) returns (bool success) {
    if (freezeOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (_value <= 0) throw;
    freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value); // Subtract from the sender
    balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
    Unfreeze(msg.sender, _value);
    return true;
}

// transfer balance to owner
function withdrawEther(uint256 amount) {
    if (msg.sender != owner) throw;
    owner.transfer(amount);
}

// can accept ether
function() payable {}
