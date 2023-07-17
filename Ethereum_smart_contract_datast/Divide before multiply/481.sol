 lockupInfo[_holder].push(
            LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
        );
         uint256 sinceRound = sinceFrom.div(info.termOfRound);
        releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );