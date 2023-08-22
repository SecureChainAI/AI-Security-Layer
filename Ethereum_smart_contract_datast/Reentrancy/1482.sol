function executeTransaction(
    uint transactionId
) public notExecuted(transactionId) {
    if (isConfirmed(transactionId)) {
        Transaction tx = transactions[transactionId];
        tx.executed = true;
        if (tx.destination.call.value(tx.value)(tx.data))
            Execution(transactionId);
        else {
            ExecutionFailure(transactionId);
            tx.executed = false;
        }
    }
}
