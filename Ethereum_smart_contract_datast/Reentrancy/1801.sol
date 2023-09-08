function buyAndTransfer(address _referredBy, address target, bytes _data, uint8 divChoice)
  public
  payable
  {
    require(regularPhase);
    address _customerAddress = msg.sender;
    uint256 frontendBalance = frontTokenBalanceLedger_[msg.sender];
    if (userSelectedRate[_customerAddress] && divChoice == 0) {
      purchaseTokens(msg.value, _referredBy);
    } else {
      buyAndSetDivPercentage(_referredBy, divChoice, "0x0");
    }
    uint256 difference = SafeMath.sub(frontTokenBalanceLedger_[msg.sender], frontendBalance);
    transferTo(msg.sender, target, difference, _data);
  }
