function _rand(uint min, uint max) private view returns (uint) {
    return (uint(keccak256(abi.encodePacked(now))) % (min + max)) - min;
}
