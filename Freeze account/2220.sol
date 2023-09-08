function freezeAccount(address target, bool freeze) public onlyOwner {
    require(!isOwner(target));
    require(!frozenAccount[target]);

    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
}
