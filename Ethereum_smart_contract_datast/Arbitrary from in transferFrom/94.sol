function safeTransferFrom(
    ERC20 token,
    address from,
    address to,
    uint256 value
) internal {
    require(token.transferFrom(from, to, value));
}
