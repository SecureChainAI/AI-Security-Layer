function lockAccount(
    address _spender,
    uint256 _value
) public onlyOwner returns (bool success) {
    lockOf[_spender] = _value * 10 ** uint256(decimals);
    return true;
}
