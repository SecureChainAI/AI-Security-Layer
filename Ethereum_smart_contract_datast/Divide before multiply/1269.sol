function buyTokens(address beneficiary) public payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

    require(weiAmount >= 5 ** 16);

    // calculate token amount to be sent
    uint256 tokens = (weiAmount / 10 ** 10) * price; // weiamount/(10**(18-decimals)) * price

    // update state
    weiRaised = weiRaised.add(weiAmount);

    tokenReward.transfer(beneficiary, tokens);
    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    forwardFunds();
}
