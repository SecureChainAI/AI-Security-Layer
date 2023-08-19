function lockedAmountOf(address _granted) public view returns (uint256) {
    require(_granted != address(0));

    uint256 lockedAmount = 0;
    uint256 lockedCount = grantedLocks[_granted].length;
    if (lockedCount > 0) {
        Lock[] storage locks = grantedLocks[_granted];
        for (uint i = 0; i < locks.length; i++) {
            if (now < locks[i].expiresAt) {
                lockedAmount = lockedAmount.add(locks[i].amount);
            }
        }
    }

    return lockedAmount;
}
