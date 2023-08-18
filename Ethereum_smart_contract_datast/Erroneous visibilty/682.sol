contract ERC20Basic {
    function balanceOf(address who) constant returns (uint256);

    function transfer(address to, uint256 value) returns (bool);
}

function transfer(address _to, uint256 _value) returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
}

function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
}

function allowance(address owner, address spender) constant returns (uint256);

function transferFrom(address from, address to, uint256 value) returns (bool);

function approve(address spender, uint256 value) returns (bool);

function allowance(
    address _owner,
    address _spender
) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
}
