function freezeAccount(
    address target,
    bool freeze
) public onlyOwner returns (bool success) {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
}
