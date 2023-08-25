function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    uint256 seed = _weiAmount.div(1 * (10 ** 9));
    return seed.mul(33);
}
