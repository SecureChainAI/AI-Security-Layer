function receiveApproval(
    address _sender,
    uint256 _value,
    address _tokenContract,
    bytes _extraData
) external canBeStoredIn128Bits(_value) whenNotPaused {
    ERC20 tokenContract = ERC20(_tokenContract);

    require(_extraData.length == 5); // 40 bits
    uint40 cutieId = getCutieId(_extraData);

    // Get a reference to the auction struct
    Auction storage auction = cutieIdToAuction[cutieId];
    require(auction.tokensAllowed); // buy for token is allowed

    require(_isOnAuction(auction));

    uint128 priceWei = _currentPrice(auction);

    uint128 priceInTokens = getPriceInToken(tokenContract, priceWei);

    // Check that bid > current price
    //require(_value >= priceInTokens);

    // Provide a reference to the seller before the auction struct is deleted.
    address seller = auction.seller;

    _removeAuction(cutieId);

    // Transfer proceeds to seller (if there are any!)
    if (priceInTokens > 0) {
        uint128 fee = _computeFee(priceInTokens);
        uint128 sellerValue = priceInTokens - fee;

        require(
            tokenContract.transferFrom(_sender, address(this), priceInTokens)
        );
        tokenContract.transfer(seller, sellerValue);
    }
    emit AuctionSuccessfulForToken(
        cutieId,
        priceWei,
        _sender,
        priceInTokens,
        _tokenContract
    );
    _transfer(_sender, cutieId);
}
