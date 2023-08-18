function _averageSalePrice(
    uint256 _saleType,
    uint256 _teamId
) internal view returns (uint256) {
    uint256 _price = 0;
    if (_saleType == 0) {
        for (uint256 ii = 0; ii < 10; ii++) {
            _price = _price.add(lastSingleSalePrices[ii]);
        }
        _price = (_price.div(10)).mul(SINGLE_SALE_MULTIPLIER.div(10));//Divide before multiply
    } else {
        for (uint256 i = 0; i < 3; i++) {
            _price = _price.add(lastTeamSalePrices[_teamId][i]);
        }

        _price = (_price.div(3)).mul(TEAM_SALE_MULTIPLIER.div(10));
        _price = _price.mul(9);
    }

    return _price;
}
