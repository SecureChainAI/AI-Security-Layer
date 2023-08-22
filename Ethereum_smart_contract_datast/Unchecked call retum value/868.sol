function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    // Adding a bonus tokens to purchase
    _tokenAmount = _tokenAmount + ((_tokenAmount * bonusPersent) / 100);
    // Сonversion from wei
    _tokenAmount = _tokenAmount / 1000000000000000000;
    token.transfer(_beneficiary, _tokenAmount);
}
