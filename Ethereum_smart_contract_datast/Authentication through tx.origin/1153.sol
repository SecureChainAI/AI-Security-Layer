 function approve(address _to, uint _tokenId)
    public
    isNotContract
  {
    // Caller must own token.
    require(_owns(msg.sender, _tokenId));

    divCardIndexToApproved[_tokenId] = _to;

    emit Approval(msg.sender, _to, _tokenId);
  }

 function purchase(uint _divCardId)
    public
    payable
    hasStarted
    isNotContract
  {
    address oldOwner  = divCardIndexToOwner[_divCardId];
    address newOwner  = msg.sender;

    // Get the current price of the card
    uint currentPrice = divCardIndexToPrice[_divCardId];

    // Making sure token owner is not sending to self
    require(oldOwner != newOwner);

    // Safety check to prevent against an unexpected 0x0 default.
    require(_addressNotNull(newOwner));

    // Making sure sent amount is greater than or equal to the sellingPrice
    require(msg.value >= currentPrice);

    // To find the total profit, we need to know the previous price
    // currentPrice      = previousPrice * (100 + percentIncrease);
    // previousPrice     = currentPrice / (100 + percentIncrease);
    uint percentIncrease = divCards[_divCardId].percentIncrease;
    uint previousPrice   = SafeMath.mul(currentPrice, 100).div(100 + percentIncrease);

    // Calculate total profit and allocate 50% to old owner, 50% to bankroll
    uint totalProfit     = SafeMath.sub(currentPrice, previousPrice);
    uint oldOwnerProfit  = SafeMath.div(totalProfit, 2);
    uint bankrollProfit  = SafeMath.sub(totalProfit, oldOwnerProfit);
    oldOwnerProfit       = SafeMath.add(oldOwnerProfit, previousPrice);

    // Refund the sender the excess he sent
    uint purchaseExcess  = SafeMath.sub(msg.value, currentPrice);

    // Raise the price by the percentage specified by the card
    divCardIndexToPrice[_divCardId] = SafeMath.div(SafeMath.mul(currentPrice, (100 + percentIncrease)), 100);

    // Transfer ownership
    _transfer(oldOwner, newOwner, _divCardId);

    // Using send rather than transfer to prevent contract exploitability.
    BANKROLL.send(bankrollProfit);
    oldOwner.send(oldOwnerProfit);

    msg.sender.transfer(purchaseExcess);
  }
 function takeOwnership(uint _divCardId)
    public
    isNotContract
  {
    address newOwner = msg.sender;
    address oldOwner = divCardIndexToOwner[_divCardId];

    // Safety check to prevent against an unexpected 0x0 default.
    require(_addressNotNull(newOwner));

    // Making sure transfer is approved
    require(_approved(newOwner, _divCardId));

    _transfer(oldOwner, newOwner, _divCardId);
  }
 function transfer(address _to, uint _divCardId)
    public
    isNotContract
  {
    require(_owns(msg.sender, _divCardId));
    require(_addressNotNull(_to));

    _transfer(msg.sender, _to, _divCardId);
  }
 function transferFrom(address _from, address _to, uint _divCardId)
    public
    isNotContract
  {
    require(_owns(_from, _divCardId));
    require(_approved(_to, _divCardId));
    require(_addressNotNull(_to));

    _transfer(_from, _to, _divCardId);
  }