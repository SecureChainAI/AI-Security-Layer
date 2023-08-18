function bid(uint256 _tokenId) public payable whenNotPaused {
    Sale memory sale = tokenIdToSale[_tokenId];
    address seller = sale.seller;
    uint256 price = _bid(_tokenId, msg.value);

    //If multi token sale
    if (sale.tokenIds[1] > 0) {
        for (uint256 i = 0; i < 9; i++) {
            _transfer(address(this), msg.sender, sale.tokenIds[i]);
        }

        //Gets Avg price
        price = price.div(9);
    } else {
        _transfer(address(this), msg.sender, _tokenId);
    }

    // If not a seed, exit
    if (seller == address(this)) {
        if (sale.tokenIds[1] > 0) {
            uint256 _teamId = nonFungibleContract.getTeamId(_tokenId);

            lastTeamSalePrices[_teamId][seedTeamSaleCount[_teamId] % 3] = price;

            seedTeamSaleCount[_teamId]++;
        } else {
            lastSingleSalePrices[seedSingleSaleCount % 10] = price;
            seedSingleSaleCount++;
        }
    }
}
