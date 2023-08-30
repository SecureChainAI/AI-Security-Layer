function freezeAccount(
    address target,
    bool freeze
) public onlyOwner whenNotPaused {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
}
