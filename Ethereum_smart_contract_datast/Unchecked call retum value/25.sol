function buyTokens(address beneficiary) public payable {
    require(beneficiary != 0x0);
    require(isCrowdsalePaused == false);
    require(validPurchase());

    
    require(TOKENS_SOLD<maxTokensToSale);
   
    uint256 weiAmount = msg.value.div(10**16);
    
    uint256 tokens = calculateTokens(weiAmount);
    require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);
    // update state
    weiRaised = weiRaised.add(msg.value);
    
    token.transfer(beneficiary,tokens);
    emit TokenPurchase(owner, beneficiary, msg.value, tokens);
    TOKENS_SOLD = TOKENS_SOLD.add(tokens);
    distributeFunds();
  }


      function takeTokensBack() public onlyOwner
     {
         uint remainingTokensInTheContract = token.balanceOf(address(this));
         token.transfer(owner,remainingTokensInTheContract);
     }