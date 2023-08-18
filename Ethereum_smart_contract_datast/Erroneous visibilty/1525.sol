function constructLeaf(
    uint256 index,
    address recipient,
    uint256 amount
) constant returns (bytes32) {
    bytes32 node = keccak256(abi.encodePacked(index, recipient, amount));
    return node;
}
