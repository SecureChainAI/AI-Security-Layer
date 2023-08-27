function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
    require(block.timestamp <= PRICE_CHANGE_ENDING_TIME);
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
}
