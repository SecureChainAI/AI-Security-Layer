function withdraw() external whenWithdrawalEnabled {
    uint256 ethBalance = ethBalances[msg.sender];
    require(ethBalance > 0);
    uint256 elpBalance = elpBalances[msg.sender];

    // reentrancy protection
    elpBalances[msg.sender] = 0;
    ethBalances[msg.sender] = 0;

    if (isWhitelisted(msg.sender)) {
        // Transfer all ELP tokens to contributor
        token.transfer(msg.sender, elpBalance); //it doesn't check the return value
    } else {
        // Transfer threshold equivalent ELP amount based on average price
        token.transfer(msg.sender, elpBalance.mul(threshold).div(ethBalance));

        if (ethBalance > threshold) {
            // Excess amount (over threshold) of contributed ETH is
            // transferred back to non-whitelisted contributor
            msg.sender.transfer(ethBalance - threshold);
        }
    }
    emit Withdrawal(msg.sender, ethBalance, elpBalance);
}

function claimTokens(address _token) public onlyOwner {
    require(_token != address(token));
    if (_token == address(0)) {
        owner.transfer(address(this).balance);
        return;
    }

    ERC20 tokenReference = ERC20(_token);
    uint balance = tokenReference.balanceOf(address(this));
    token.transfer(owner, balance);//it doesn't check the return value
    emit ClaimedTokens(_token, owner, balance);
}
