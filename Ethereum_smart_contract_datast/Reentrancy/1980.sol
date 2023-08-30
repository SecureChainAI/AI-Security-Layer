function executeTransaction(
    uint transactionId
)
    public
    ownerExists(msg.sender)
    confirmed(transactionId, msg.sender)
    notExecuted(transactionId)
{
    Transaction storage txn = transactions[transactionId];
    bool _confirmed = isConfirmed(transactionId);
    if (_confirmed || (txn.data.length == 0 && isUnderLimit(txn.value))) {
        txn.executed = true;
        if (!_confirmed) spentToday += txn.value;
        if (txn.destination.call.value(txn.value)(txn.data))
            emit Execution(transactionId);
        else {
            emit ExecutionFailure(transactionId);
            txn.executed = false;
            if (!_confirmed) spentToday -= txn.value;
        }
    }
}
