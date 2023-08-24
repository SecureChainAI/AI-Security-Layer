function _settleAndRestart() private {
    gameActive = false;
    uint payment = tokensInPlay / 2;
    contractBalance = contractBalance.sub(payment);

    if (tokensInPlay > 0) {
        ZTHTKN.transfer(currentWinner, payment);
        if (address(this).balance > 0) {
            ZTHBANKROLL.transfer(address(this).balance);
        }
    }

    emit GameEnded(currentWinner, payment, now);

    // Reset values.
    tokensInPlay = tokensInPlay.sub(payment);
    gameActive = true;
}
