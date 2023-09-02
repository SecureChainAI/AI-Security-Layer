function() public payable {
    require(totalAirDropToken > 0);
    require(balanceOf[msg.sender] == 0);
    uint256 amount = getCurrentCandyAmount();
    require(amount > 0);

    totalAirDropToken = totalAirDropToken.sub(amount);
    balanceOf[msg.sender] = amount;

    tokenRewardContract.transfer(msg.sender, amount * 1e18);
    emit FundTransfer(msg.sender, amount, true);
}
