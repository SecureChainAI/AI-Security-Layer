function LockAccount(address toLock) public onlyOwner {
    lockedAccounts[toLock] = true;
}
