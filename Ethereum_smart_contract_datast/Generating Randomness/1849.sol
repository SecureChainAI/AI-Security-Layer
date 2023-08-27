function random(uint32 _upper, uint32 _lower) private returns (uint32) {
    require(_upper > _lower);

    seed = uint32(
        keccak256(keccak256(block.blockhash(block.number - 1), seed), now)
    );
    return (seed % (_upper - _lower)) + _lower;
}
