        uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
                referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
                _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
                    _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
        uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); // 50% of dividends: 10%
                _dividends = SafeMath.add(_dividends, (_referralBonus*30 / 100));
                referralBalance_[tier2] = SafeMath.add(referralBalance_[tier2], (_referralBonus*30 / 100)); // Tier 2 gets 30% of referrals (3%)
                    _dividends = SafeMath.add(_dividends, (_referralBonus*20 / 100));
            _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
 uint256 _etherReceived =
        (
            // underflow attempts BTFO
            SafeMath.sub(
                (
                    (
                        (
                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
                        )-tokenPriceIncremental_
                    )*(tokens_ - 1e18)
                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
            )
        /1e18);
