function playerWithdrawPendingTransactions()
    public
    payoutsAreActive
    returns (bool)
{
    uint withdrawAmount = playerPendingWithdrawals[msg.sender];
    playerPendingWithdrawals[msg.sender] = 0;
    /* external call to untrusted contract */
    if (msg.sender.call.value(withdrawAmount)()) {
        return true;
    } else {
        /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
        /* player can try to withdraw again later */
        playerPendingWithdrawals[msg.sender] = withdrawAmount;
        return false;
    }
}
