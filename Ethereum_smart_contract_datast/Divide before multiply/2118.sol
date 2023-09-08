    uint256 tokens = _cents.mul(10 ** 18).div(tokenPriceInCents);
    uint256 bonusTokens = tokens.mul(bonusPercent).div(100);
