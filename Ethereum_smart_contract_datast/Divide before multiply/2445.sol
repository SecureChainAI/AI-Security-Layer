   uint256 totalFullCoins = (totalCoins.add(dec_mul.div(2))).div(dec_mul);
        uint256 tokensWithBonusX100 = bonusRate.mul(totalFullCoins);
        uint256 fullCoins = (tokensWithBonusX100.add(50)).div(100);
        return fullCoins.mul(dec_mul);
