function transfer(address _to, uint256 _value) returns (bool success) {
    require(_to != address(0));
    if (accounts[msg.sender] < _value) return false;
    if (_value > 0 && msg.sender != _to) {
        accounts[msg.sender] = safeSub(accounts[msg.sender], _value);
        accounts[_to] = safeAdd(accounts[_to], _value);
    }
    emit Transfer(msg.sender, _to, _value);
    return true;
}

function transferFrom(
    address _from,
    address _to,
    uint256 _value
) returns (bool success) {
    require(_to != address(0));
    if (allowances[_from][msg.sender] < _value) return false;
    if (accounts[_from] < _value) return false;

    if (_value > 0 && _from != _to) {
        allowances[_from][msg.sender] = safeSub(
            allowances[_from][msg.sender],
            _value
        );
        accounts[_from] = safeSub(accounts[_from], _value);
        accounts[_to] = safeAdd(accounts[_to], _value);
    }
    emit Transfer(_from, _to, _value);
    return true;
}

function approve(address _spender, uint256 _value) returns (bool success) {
    allowances[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
}

function allowance(
    address _owner,
    address _spender
) constant returns (uint256 remaining) {
    return allowances[_owner][_spender];
}

function totalSupply() constant returns (uint256 supply) {
    return tokenCount;
}

function RABAToken() {
    owner = msg.sender;
}

function refundTokens(address _token, address _refund, uint256 _value) {
    require(msg.sender == owner);
    require(_token != address(this));
    AbstractToken token = AbstractToken(_token);
    token.transfer(_refund, _value);
    emit RefundTokens(_token, _refund, _value);
}

function freezeAccount(address _target, bool freeze) {
    require(msg.sender == owner);
    require(msg.sender != _target);
    frozenAccount[_target] = freeze;
    emit FrozenFunds(_target, freeze);
}
