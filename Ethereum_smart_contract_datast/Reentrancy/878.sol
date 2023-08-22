function getTokens() public payable canDistr {
    uint256 tokens = 0;

    require(msg.value >= minContribution);

    require(msg.value > 0);

    tokens = tokensPerEth.mul(msg.value) / 1 ether;
    address investor = msg.sender;

    if (tokens > 0) {
        distr(investor, tokens);
    }

    if (totalDistributed >= totalSupply) {
        distributionFinished = true;
    }
}
