function receiveApproval(
    address _sender,
    uint256 _value,
    BitGuildToken _tokenContract,
    bytes _extraData
) public whenNotPaused {
    require(msg.sender != address(0));
    require(_tokenContract == platContract);
    require(_tokenContract.transferFrom(_sender, address(this), _value));
    require(_extraData.length != 0);

    uint256 _amount;
    for (uint256 i = 0; i < _extraData.length; i++) {
        _amount =
            _amount +
            uint(_extraData[i]) *
            (2 ** (8 * (_extraData.length - (i + 1))));
    }

    // Up to 5 purchases at once.
    require(_amount >= 1 && _amount <= 5);

    uint256 _priceOfBundle = (_amount *
        ethPrice *
        platPriceOracleContract.ETHPrice()) / (10 ** 18);

    // Sent PLAT tokens should be more than the price of bundle.
    require(_value >= _priceOfBundle);

    payWithPLAT(_amount);
}
