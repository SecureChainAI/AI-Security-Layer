function _getTokenAmount(
    uint256 _usdCents
) public view CrowdsaleStarted returns (uint256) {
    uint256 tokens;

    if (
        block.number > preIcoStartBlock &&
        block.number < discountedIcoStartBlock
    ) tokens = _usdCents.div(100).mul(presaleTokensPerDollar);
    if (
        block.number >= discountedIcoStartBlock &&
        block.number < mainIcoStartBlock
    ) tokens = _usdCents.div(100).mul(discountedTokensPerDollar);
    if (block.number >= mainIcoStartBlock && block.number < mainIcoEndBlock)
        tokens = _usdCents.div(100).mul(mainTokensPerDollar);

    return tokens;
}
