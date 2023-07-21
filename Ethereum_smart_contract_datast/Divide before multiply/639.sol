function getTokenPrice(
    uint256 tokenId
) public view isOnMarket(tokenId) returns (uint256) {
    return
        market[tokenId].price +
        (market[tokenId].price.div(100).mul(marketMakerFee));
}

function _updateDistribution() internal {
    require(toBeDistributed != 0, "nothing to distribute");
    uint256 knightPayday = toBeDistributed.div(100).mul(knightEquity);
    uint256 paladinPayday = toBeDistributed.div(100).mul(paladinEquity);

    /// @dev due to the equities distribution, queen gets the remaining value
    uint256 jokerPayday = toBeDistributed.sub(knightPayday).sub(paladinPayday);

    _cBalance[jokerAddress] = _cBalance[jokerAddress].add(jokerPayday);
    _cBalance[knightAddress] = _cBalance[knightAddress].add(knightPayday);
    _cBalance[paladinAddress] = _cBalance[paladinAddress].add(paladinPayday);
    //Reset balance to 0
    toBeDistributed = 0;
}
