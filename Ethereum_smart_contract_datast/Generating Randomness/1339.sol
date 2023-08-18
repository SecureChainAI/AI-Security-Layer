function doRandom(
    address[] _address,
    uint _linuxTime
) private view returns (uint) {
    return uint(keccak256(block.difficulty, now, _address, _linuxTime));
}
