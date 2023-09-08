            q = r / newR;
            (r, newR) = (newR, r - q * newR );
        uint256 serviceReward = taskReard.mul(serviceFee).div(MAX_PERCENT); // 1%
            uint256 referrerReward = serviceReward.mul(referrerFee).div(MAX_PERCENT); // 50% of service reward
