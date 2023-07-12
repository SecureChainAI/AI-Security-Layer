            poolFee = msg.value.mul(stakingPrecent).div(100);
            uint256 globalIncrease = globalFactor.mul(poolFee) / _etherBeforeBuyIn;
