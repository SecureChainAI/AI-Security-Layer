function lock(
    address _granted,
    uint256 _amount,
    uint256 _expiresAt
) public onlyOwnerOrAdmin(ROLE_LOCKUP) {
    require(_amount > 0);
    require(_expiresAt > now);

    grantedLocks[_granted].push(Lock(_amount, _expiresAt));

    emit Locked(_granted, _amount, _expiresAt);
}
