function lockup(address _target) public onlyOwner returns (bool success) {
    require(!isOwner(_target));

    locked[_target] = true;
    emit LogLockup(_target);
    return true;
}
