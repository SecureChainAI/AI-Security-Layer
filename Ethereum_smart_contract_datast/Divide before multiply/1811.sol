        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
        uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends,maintenanceFee),100);
        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
        uint256 _maintenance = SafeMath.div(SafeMath.mul(_undividedDividends,maintenanceFee),100);
        uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
            _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
