    bool isPresale = block.timestamp >= PRESALE_OPENING_TIME && block.timestamp <= PRESALE_CLOSING_TIME && presaleWeiRaised.add(weiAmount) <= PRESALE_WEI_CAP;
    bool isCrowdsale = block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME && presaleGoalReached() && crowdsaleWeiRaised.add(weiAmount) <= CROWDSALE_WEI_CAP;
    require(block.timestamp >= CROWDSALE_OPENING_TIME && block.timestamp <= CROWDSALE_CLOSING_TIME);
      if (elapsedTime < crowdsaleMinElapsedTimeLevels[i]) continue;
    require(block.timestamp > PRESALE_CLOSING_TIME);
    require(block.timestamp > CROWDSALE_CLOSING_TIME);
