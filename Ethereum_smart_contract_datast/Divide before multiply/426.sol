uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, selldividendFee_), 100);
        uint256 _xPayout = SafeMath.div(SafeMath.mul(_ethereum, xFee_), 100);
            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
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