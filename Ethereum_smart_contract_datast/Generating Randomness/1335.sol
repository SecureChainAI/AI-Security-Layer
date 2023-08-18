function randomGen(
    uint seed,
    uint count
) private view returns (uint randomNumber) {
    return uint(keccak256(abi.encodePacked(block.number - 3, seed))) % count;
}
