    require(now < _lastLockingTime);
    require(now >= lockedUntil || allFundsCanBeUnlocked);
    require(now <= lastLockingTime);
    require(now < _lockedUntil);
