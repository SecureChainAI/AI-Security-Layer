function freeze(
    address _addr,
    uint256 _value
) public onlyOwner returns (bool success) {
    require(balances[_addr] >= _value);
    require(_value > 0);
    balances[_addr] = sub(balances[_addr], _value);
    frozen[_addr] = add(frozen[_addr], _value);
    emit Freeze(_addr, _value);
    return true;
}

function frozenOf(address _owner) public view returns (uint256 balance) {
    return frozen[_owner];
}
