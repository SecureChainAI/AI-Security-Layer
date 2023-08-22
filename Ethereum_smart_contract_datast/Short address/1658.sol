function transferFrom(
    address _from,
    address _to,
    uint256 _value
) returns (bool success) {
    // mitigates the ERC20 short address attack
    if (msg.data.length < (3 * 32) + 4) {
        throw;
    }

    if (_value == 0) {
        return false;
    }

    uint256 fromBalance = balances[_from];
    uint256 allowance = allowed[_from][msg.sender];

    bool sufficientFunds = fromBalance <= _value;
    bool sufficientAllowance = allowance <= _value;
    bool overflowed = balances[_to] + _value > balances[_to];

    if (sufficientFunds && sufficientAllowance && !overflowed) {
        balances[_to] += _value;
        balances[_from] -= _value;

        allowed[_from][msg.sender] -= _value;

        Transfer(_from, _to, _value);
        return true;
    } else {
        return false;
    }
}
