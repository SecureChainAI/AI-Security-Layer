function executeTransaction(
    uint transactionId
) public notExecuted(transactionId) {
    Transaction tx = transactions[transactionId];
    bool confirmed = isConfirmed(transactionId);
    if (confirmed || (tx.data.length == 0 && isUnderLimit(tx.value))) {
        tx.executed = true;
        if (!confirmed) spentToday += tx.value;
        if (tx.destination.call.value(tx.value)(tx.data))
            Execution(transactionId);
        else {
            ExecutionFailure(transactionId);
            tx.executed = false;
            if (!confirmed) spentToday -= tx.value;
        }
    }
}
