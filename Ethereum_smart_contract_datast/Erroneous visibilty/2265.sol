function totalSupply() constant returns (uint256) {
    return _totalSupply;
}

function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
}

function transfer(address _to, uint256 _amount) returns (bool success) {
    if (
        balances[msg.sender] >= _amount &&
        _amount > 0 &&
        balances[_to] + _amount > balances[_to]
    ) {
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(msg.sender, _to, _amount);
        return true;
    } else {
        return false;
    }
}

function transferFrom(
    address _from,
    address _to,
    uint256 _amount
) returns (bool success) {
    if (
        balances[_from] >= _amount &&
        allowed[_from][msg.sender] >= _amount &&
        _amount > 0 &&
        balances[_to] + _amount > balances[_to]
    ) {
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(_from, _to, _amount);
        return true;
    } else {
        return false;
    }
}

function approve(address _spender, uint256 _amount) returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
}

function allowance(
    address _owner,
    address _spender
) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
}
