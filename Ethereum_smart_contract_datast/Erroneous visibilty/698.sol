function transfer(address _to, uint _value) returns (bool success) {
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[_to] = safeAdd(balances[_to], _value);
    Transfer(msg.sender, _to, _value);
    return true;
}

function transferFrom(
    address _from,
    address _to,
    uint _value
) returns (bool success) {
    uint _allowance = allowed[_from][msg.sender];

    balances[_to] = safeAdd(balances[_to], _value);
    balances[_from] = safeSub(balances[_from], _value);
    allowed[_from][msg.sender] = safeSub(_allowance, _value);
    Transfer(_from, _to, _value);
    return true;
}

function balanceOf(address _owner) constant returns (uint balance) {
    return balances[_owner];
}

function approve(address _spender, uint _value) returns (bool success) {
    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}

function allowance(
    address _owner,
    address _spender
) constant returns (uint remaining) {
    return allowed[_owner][_spender];
}

function transferFrom(
    address _from,
    address _to,
    uint _value
) canTransfer(_from) returns (bool success) {
    // Call StandardToken.transferForm()
    return super.transferFrom(_from, _to, _value);
}

library SafeMathLibExt {
    function times(uint a, uint b) returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function divides(uint a, uint b) returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + (a % b));
        return c;
    }

    function minus(uint a, uint b) returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function plus(uint a, uint b) returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }
}
