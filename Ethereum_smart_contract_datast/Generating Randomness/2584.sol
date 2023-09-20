function maxRandom(
    uint blockn,
    address entropy
) public view returns (uint256 randomNumber) {
    return uint256(keccak256(abi.encodePacked(blockhash(blockn), entropy)));
}

function random(
    uint256 upper,
    uint256 blockn,
    address entropy
) internal view returns (uint256 randomNumber) {
    return maxRandom(blockn, entropy) % upper;
}
