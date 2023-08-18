function computeTokens(uint256 weiAmount) internal view returns (uint256) {
    return (weiAmount.div(rate)) * (10 ** 18);
}
