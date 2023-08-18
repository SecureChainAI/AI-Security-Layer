function splitTokens() internal {
    token.mint(techDevelopmentEthWallet, ((totalTokens * 3).div(100))); //wallet for tech development
    tokensIssuedTillNow = tokensIssuedTillNow + ((totalTokens * 3).div(100));
    token.mint(operationsEthWallet, ((totalTokens * 7).div(100))); //wallet for operations wallet
    tokensIssuedTillNow = tokensIssuedTillNow + ((totalTokens * 7).div(100));
}
