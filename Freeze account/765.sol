function freezeAccount(address target, bool freeze) public onlyOwner {
    require(target != 0x0);
    require(freeze == (true || false));
    frozenAccounts[target] = freeze;
    emit FrozenFund(target, freeze); // solhint-disable-line
}
