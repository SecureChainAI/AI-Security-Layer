function tokenFallback(
    address _from,
    uint _value,
    bytes /* _data */
) public returns (bool) {
    TKN memory _tkn;
    _tkn.sender = _from;
    _tkn.value = _value;
    _stakeTokens(_tkn);
    return true;
}
