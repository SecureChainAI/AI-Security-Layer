function random(
    uint256 upper,
    uint256 blockn,
    address entropy
) public view returns (uint256 randomNumber) {
    return maxRandom(blockn, entropy) % upper;
}
