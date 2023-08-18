function _rand() private view returns (uint256) {
    uint256 rand = uint256(sha3(now, block.number, randSeed));
    return rand %= (10 ** 6);
}
