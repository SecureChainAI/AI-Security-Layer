function freezeAccounts(address[] targets, bool isFrozen) public onlyOwner {
    require(targets.length > 0);

    for (uint c = 0; c < targets.length; c++) {
        require(targets[c] != 0x0);
        frozenAccount[targets[c]] = isFrozen;
        FrozenFunds(targets[c], isFrozen);
    }
}
