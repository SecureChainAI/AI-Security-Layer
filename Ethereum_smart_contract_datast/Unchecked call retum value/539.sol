function withdrawFunds() public onlyOnceLockingPeriodIsOver(msg.sender) {
    uint amountToBeTransferred = lockingData[msg.sender]["amount"];
    lockingData[msg.sender]["amount"] = 0;
    VerityToken(tokenAddress).transfer(msg.sender, amountToBeTransferred);

    emit Withdrawn(msg.sender, amountToBeTransferred);
}
