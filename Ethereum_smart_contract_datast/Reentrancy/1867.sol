function endIco() internal {
    currentStage = Stages.icoEnd;
    // Transfer any remaining tokens
    if (remainingTokens > 0)
        balances[owner] = balances[owner].add(remainingTokens);
    // transfer any remaining ETH balance in the contract to the owner
    owner.transfer(address(this).balance);
}
