function buyTokens(address beneficiary) public payable saleIsOn {
    require(beneficiary != address(0));
    uint256 weiAmount = (msg.value).div(10 ** 10);
    uint256 all = 100;
    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);
    require(tokens >= minTokensToSale);
    uint256 bonusNow = getBonus(tokens);
    tokens = tokens.mul(bonusNow).div(all);
    require(tokensToSale > tokens.add(token.totalSupply()));
    weiRaised = weiRaised.add(msg.value);
    token.mint(beneficiary, tokens);
    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    wallet.transfer(msg.value);
}
