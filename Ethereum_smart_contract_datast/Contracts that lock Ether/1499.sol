function lockupAccounts(address[] targets, uint[] unixTimes) public onlyOwner {
    require(hasSameArrayLength(targets, unixTimes));

    for (uint j = 0; j < targets.length; j++) {
        require(unlockUnixTime[targets[j]] < unixTimes[j]);
        unlockUnixTime[targets[j]] = unixTimes[j];
        emit LockedFunds(targets[j], unixTimes[j]);
    }
}
