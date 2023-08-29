function _getRandom(
    uint256 _modulus
) internal onlyAccessByGame returns (uint32) {
    randNonce = randNonce.add(1);
    return
        uint32(
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
                _modulus
        );
    //    return uint8(uint256(keccak256(block.timestamp, block.difficulty))%251);
}
