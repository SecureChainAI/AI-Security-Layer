            uint256 periodTokens = totalBalance.div(periods);
            uint256 periodsOver = now.sub(start).div(duration);
            return periodTokens.mul(periodsOver);
