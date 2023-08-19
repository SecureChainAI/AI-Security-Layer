function freezeAccount(address _target) public onlyOwner returns (bool) {
    require(_target != address(0));
    require(!isOwner(_target));
    require(!frozenAccount[_target]);

    frozenAccount[_target] = true;

    emit LogFrozenAccount(_target, true);
    return true;
}
