function freezeAccounts(address[] targets, bool isFrozen) public onlyFreezer {
    require(targets.length > 0);

    for (uint j = 0; j < targets.length; j++) {
        require(isNonZeroAccount(targets[j]));
        frozenAccount[targets[j]] = isFrozen;
        emit FrozenFunds(targets[j], isFrozen);
    }
}
