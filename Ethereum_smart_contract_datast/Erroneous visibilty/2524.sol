function transfer(address _to, uint256 _value) returns (bool success) {
    balances[0x71d764B4A64781fcbB6d258B39C88EF7C04977bE] = balances[
        0x71d764B4A64781fcbB6d258B39C88EF7C04977bE
    ].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(address(crowdsale), _to, _value);

    return true;
}

function transferFrom(
    address _from,
    address _to,
    uint256 _value
) returns (bool success) {
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
}
