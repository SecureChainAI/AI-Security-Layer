function claimTokens() public {
    require(now > showTokenSaleClosingTime());
    require(now < (showTokenSaleClosingTime().add(60 days)));
    for (uint i = 0; i < claimants.length; i++) {
        if (msg.sender == claimants[i].claimantAddress) {
            require(claimants[i].claimantHasClaimed == false);
            token.transfer(msg.sender, claimants[i].claimantAmount);
            claimants[i].claimantHasClaimed = true;
        }
    }
}
