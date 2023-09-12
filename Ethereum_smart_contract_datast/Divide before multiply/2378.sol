function closeSale(address _investor, uint256 _value) internal {
    uint256 tokens = _value.mul(1e18).div(buyPrice); // 68%
    uint256 bonusTokens = tokens.mul(30).div(100); // + 30% per stage
    tokens = tokens.add(bonusTokens);
    token.transferFromICO(_investor, tokens);
    weisRaised = weisRaised.add(msg.value);

    uint256 tokensReserve = tokens.mul(15).div(68); // 15 %
    token.transferFromICO(reserve, tokensReserve);

    uint256 tokensBoynty = tokens.div(34); // 2 %
    token.transferFromICO(bounty, tokensBoynty);

    uint256 tokensPromo = tokens.mul(15).div(68); // 15%
    token.transferFromICO(promouters, tokensPromo);
}
