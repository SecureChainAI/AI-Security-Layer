function() public payable isRunning {
    require(msg.value >= minPurchase);

    uint256 unsold = forSale.subtract(totalSold);
    uint256 paid = msg.value;
    uint256 purchased = paid.divide(price);
    if (purchased > unsold) {
        purchased = unsold;
    }
    uint256 toReturn = paid.subtract(purchased.multiply(price));
    uint256 reward = purchased.multiply(30).divide(100); // 30% bonus reward

    if (toReturn > 0) {
        msg.sender.transfer(toReturn);
    }
    token.transfer(msg.sender, purchased.add(reward));
    allocateFunds();
    totalSold = totalSold.add(purchased);
}
