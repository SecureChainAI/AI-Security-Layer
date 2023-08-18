contract Token {
    function totalSupply() constant returns (uint256 supply);

    function balanceOf(address _owner) constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success);

    function approve(address _spender, uint256 _value) returns (bool success);

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining);
}

function AbstractToken() {
    // Do nothing
}

function balanceOf(address _owner) constant returns (uint256 balance) {
    return accounts[_owner];
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

function transfer(address _to, uint256 _value) returns (bool success) {
    require(!frozenAccount[msg.sender]);
    if (frozen) return false;
    else return AbstractToken.transfer(_to, _value);
}

function approve(address _spender, uint256 _value) returns (bool success) {
    require(allowance(msg.sender, _spender) == 0 || _value == 0);
    return AbstractToken.approve(_spender, _value);
}
