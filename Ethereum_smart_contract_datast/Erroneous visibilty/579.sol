function Planethereum(address _addressFounder) {
    owner = msg.sender;
    totalSupply = valueFounder;
    balanceOf[_addressFounder] = valueFounder;
    Transfer(0x0, _addressFounder, valueFounder);
}

function transfer(
    address _to,
    uint256 _value
) isRunning validAddress returns (bool success) {
    require(balanceOf[msg.sender] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
}

function transferFrom(
    address _from,
    address _to,
    uint256 _value
) isRunning validAddress returns (bool success) {
    require(balanceOf[_from] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);
    require(allowance[_from][msg.sender] >= _value);
    balanceOf[_to] += _value;
    balanceOf[_from] -= _value;
    allowance[_from][msg.sender] -= _value;
    Transfer(_from, _to, _value);
    return true;
}

function approve(
    address _spender,
    uint256 _value
) isRunning validAddress returns (bool success) {
    require(_value == 0 || allowance[msg.sender][_spender] == 0);
    allowance[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}

function stop() isOwner {
    stopped = true;
}

function start() isOwner {
    stopped = false;
}

function setName(string _name) isOwner {
    name = _name;
}

function burn(uint256 _value) {
    require(balanceOf[msg.sender] >= _value);
    balanceOf[msg.sender] -= _value;
    balanceOf[0x0] += _value;
    Transfer(msg.sender, 0x0, _value);
}
