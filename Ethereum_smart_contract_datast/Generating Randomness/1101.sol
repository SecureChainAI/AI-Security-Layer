function random(
    uint256 upper,
    uint256 blockn,
    address entropy
) internal view returns (uint256 randomNumber) {
    return maxRandom(blockn, entropy) % upper;
}
