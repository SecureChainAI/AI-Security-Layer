    function () public payable  {
      if(msg.value<1) revert();
      if(totalDividend+msg.value<totalDividend) revert();
      if(token.totalSupply()+totalSupply<totalSupply) revert();
      totalDividend+=msg.value;
      totalSupply+=token.totalSupply();
      divMultiplier=totalDividend/totalSupply;
      emit Dividend(msg.value);
    }
    function withdrawDividend() payable public {
        uint due=(token.balanceOf(msg.sender)*divMultiplier)-claimed[msg.sender];
        if(due+claimed[msg.sender]<claimed[msg.sender]) revert();        
        claimed[msg.sender]+=due;
        totalClaimed+=due;
        msg.sender.transfer(due);
        emit Payed(msg.sender,due);
    }
