function redeemTokens(
    uint256 index,
    uint256 amount,
    bytes32[] _proof
) public whenNotPaused returns (bool) {
    bytes32 node = constructLeaf(index, msg.sender, amount);
    require(!redeemed[node]);
    require(isProofValid(_proof, node));
    redeemed[node] = true;
    token.transfer(msg.sender, amount);
}
