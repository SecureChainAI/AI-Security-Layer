    require(_startTime >=now);
        if (timeElapsedInDays <15)
        else if (timeElapsedInDays >=15 && timeElapsedInDays <30)
        else if (timeElapsedInDays >=30 && timeElapsedInDays <45)
    bool withinPeriod = now >= startTime && now <= endTime;
    return withinPeriod && nonZeroPurchase && withinContributionLimit;
    return now > endTime;
         uint remainingTokensInTheContract = token.balanceOf(address(this));
