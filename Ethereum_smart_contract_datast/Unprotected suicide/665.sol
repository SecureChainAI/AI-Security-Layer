function withdrawTokens() private whenInitialized {
    uint256 tokensToSend = getAvailableTokensToWithdraw();
    sendTokens(tokensToSend);
    if (dreamToken.balanceOf(this) == 0) {
        // When all tokens were sent, destroy this smart contract
        selfdestruct(withdrawalAddress);
    }
}
