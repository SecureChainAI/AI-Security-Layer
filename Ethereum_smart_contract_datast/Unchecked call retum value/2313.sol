function() public {
    uint256 currentBalance = token.balanceOf(this);
    uint256 additionalTokens = currentBalance - latestTokenBalance;

    //all new tokens are under same rules as transfereed on the begining
    totalTokenBalance = totalTokenBalance + additionalTokens;
    uint withdrawAmount = calculateSumToWithdraw();

    token.transfer(beneficiary, withdrawAmount);
    latestTokenBalance = token.balanceOf(this);
}
