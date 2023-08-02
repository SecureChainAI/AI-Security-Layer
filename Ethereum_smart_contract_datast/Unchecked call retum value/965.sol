function procureTokens(address _beneficiary) public payable {
    uint256 tokens;
    uint256 weiAmount = msg.value;
    address _this = this;
    uint256 rate;
    address referer;
    uint256 refererTokens;
    require(now >= startPreICO);
    require(now <= endICO);
    require(_beneficiary != address(0));
    checkMinMaxInvestment(weiAmount);
    rate = getRate();
    tokens = weiAmount.mul(rate);
    //referral system
    if (msg.data.length == 20) {
        referer = bytesToAddress(bytes(msg.data));
        require(referer != msg.sender);
        //add tokens to the referrer
        refererTokens = tokens.mul(5).div(100);
    }
    checkHardCap(tokens.add(refererTokens));
    adjustHardCap(tokens.add(refererTokens));
    wallet.transfer(_this.balance);
    if (
        refererTokens != 0 &&
        allRefererTokens.add(refererTokens) <= maxRefererTokens
    ) {
        allRefererTokens = allRefererTokens.add(refererTokens);
        token.mint(referer, refererTokens);
    }
    token.mint(_beneficiary, tokens);
    emit TokenProcurement(msg.sender, _beneficiary, weiAmount, tokens);
}
