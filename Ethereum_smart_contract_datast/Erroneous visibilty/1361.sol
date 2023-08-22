function updateCABoxToken(address _tokenAddress) onlyOwner {
    require(_tokenAddress != address(0));
    token.transferOwnership(_tokenAddress);

    TokenContractUpdated(true);
}
