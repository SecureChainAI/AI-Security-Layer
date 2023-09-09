function addTokenGrant(
    address _recipient,
    uint256 _startTime,
    uint128 _amount,
    uint16 _vestingDuration,
    uint16 _vestingCliff
) public onlyColonyMultiSig noGrantExistsForUser(_recipient) {
    require(_vestingCliff > 0);
    require(_vestingDuration > _vestingCliff);
    uint amountVestedPerMonth = _amount / _vestingDuration;
    require(amountVestedPerMonth > 0);

    // Transfer the grant tokens under the control of the vesting contract
    token.transferFrom(colonyMultiSig, address(this), _amount);

    Grant memory grant = Grant({
        startTime: _startTime == 0 ? now : _startTime,
        amount: _amount,
        vestingDuration: _vestingDuration,
        vestingCliff: _vestingCliff,
        monthsClaimed: 0,
        totalClaimed: 0
    });

    tokenGrants[_recipient] = grant;
    emit GrantAdded(
        _recipient,
        grant.startTime,
        _amount,
        _vestingDuration,
        _vestingCliff
    );
}
