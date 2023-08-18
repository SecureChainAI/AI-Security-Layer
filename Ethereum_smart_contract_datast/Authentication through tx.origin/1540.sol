function TokenLiquidityMarket(
    address _traded_token,
    uint256 _eth_seed_amount,
    uint256 _traded_token_seed_amount,
    uint256 _commission_ratio
) public {
    admin = tx.origin;
    platform = msg.sender;
    traded_token = _traded_token;
    eth_seed_amount = _eth_seed_amount;
    traded_token_seed_amount = _traded_token_seed_amount;
    commission_ratio = _commission_ratio;
}
