function freezeAccount(address _target, bool _freeze) public onlyOwner {
    frozenAccounts[_target] = _freeze;
    emit FrozenFunds(_target, _freeze);
}
