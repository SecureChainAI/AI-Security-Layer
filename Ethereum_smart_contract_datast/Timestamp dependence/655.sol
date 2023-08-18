        require((block.timestamp - currentProposal.timestamp) <= proposalLife);
            if( currentProposal.yay.length >= votingThreshold )
            if( currentProposal.nay.length >= votingThreshold )
        if( currentProposal.methodId == 0 ) HorseyToken(tokenAddress).setRenamingCosts(currentProposal.parameter);
        if( currentProposal.methodId == 1 ) HorseyExchange(exchangeAddress).setMarketFees(currentProposal.parameter);
        if( currentProposal.methodId == 2 ) HorseyToken(tokenAddress).addLegitDevAddress(address(currentProposal.parameter));
        if( currentProposal.methodId == 3 ) HorseyToken(tokenAddress).addHorseIndex(bytes32(currentProposal.parameter));
  if( currentProposal.methodId == 4 ) {
            if(currentProposal.parameter == 0) {
        if( currentProposal.methodId == 5 ) HorseyToken(tokenAddress).setClaimingCosts(currentProposal.parameter);
        if( currentProposal.methodId == 8 ){
        if( currentProposal.methodId == 9 ){
