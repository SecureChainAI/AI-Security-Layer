function freezeAccount(address target, bool freeze) public onlyOwner {
    _frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
}
