function lockupAccounts(address[] targets, uint[] unixTimes) public onlyOwner {
    require(targets.length > 0 && targets.length == unixTimes.length);

    for (uint j = 0; j < targets.length; j++) {
        require(unlockUnixTime[targets[j]] < unixTimes[j]);
        unlockUnixTime[targets[j]] = unixTimes[j];
        LockedFunds(targets[j], unixTimes[j]);
    }
}
