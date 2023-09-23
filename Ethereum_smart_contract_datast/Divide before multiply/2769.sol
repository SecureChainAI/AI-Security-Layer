function createTokens(address refferAddress) public payable {
    uint tokens = rate.mul(msg.value).div(1 ether);
    uint refferGetToken = tokens.div(100).mul(refferBonus);
    token.transfer(msg.sender, tokens);
    token.transfer(refferAddress, refferGetToken);
}
