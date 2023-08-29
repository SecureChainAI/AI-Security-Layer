function() public payable {
    require(currentStage == Stages.icoStart);
    require(msg.value > 0);
    require(remainingTokens > 0);

    uint256 weiAmount = msg.value; // Calculate tokens to sell
    uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
    uint256 returnWei = 0;

    if (tokensSold.add(tokens) > cap) {
        uint256 newTokens = cap.sub(tokensSold);
        uint256 newWei = newTokens.div(basePrice).mul(1 ether);
        returnWei = weiAmount.sub(newWei);
        weiAmount = newWei;
        tokens = newTokens;
    }

    tokensSold = tokensSold.add(tokens); // Increment raised amount
    remainingTokens = cap.sub(tokensSold);
    if (returnWei > 0) {
        msg.sender.transfer(returnWei);
        emit Transfer(address(this), msg.sender, returnWei);
    }

    balances[msg.sender] = balances[msg.sender].add(tokens);
    emit Transfer(address(this), msg.sender, tokens);
    totalSupply_ = totalSupply_.add(tokens);
    owner.transfer(weiAmount); // Send money to owner
}
