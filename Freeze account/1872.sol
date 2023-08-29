function freezeAccount(address target, bool freeze) public onlyOwner {
    frozenAccount[target] = freeze;
    emit FrozenFunds(target, freeze);
}

function freezeAccountWithToken(
    address wallet,
    uint256 _value
) public onlyOwner returns (bool success) {
    require(balances[wallet] >= _value);
    require(_value > 0);
    frozenAccountTokens[wallet] = SafeMath.add(
        frozenAccountTokens[wallet],
        _value
    );
    emit Freeze(wallet, _value);
    return true;
}
