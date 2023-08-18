function lockFunds(
    uint _tokens
)
    public
    checkValidLockingTime
    checkLockIsNotTerminated
    checkUsersTokenBalance(_tokens)
    checkValidLockingAmount(_tokens)
    onlyOncePerUser(msg.sender)
{
    require(
        VerityToken(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokens
        )
    );

    lockingData[msg.sender]["amount"] = _tokens;
    lockingData[msg.sender]["lockedUntil"] = validLockingAmountToPeriod[
        _tokens
    ];

    emit FundsLocked(msg.sender, _tokens, validLockingAmountToPeriod[_tokens]);
}
