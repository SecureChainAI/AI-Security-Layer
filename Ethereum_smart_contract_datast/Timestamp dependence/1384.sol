    require(_startTime >= now);
    bool withinPeriod = now >= startTime && now <= endTime;
    return withinPeriod && nonZeroPurchase;
    return now > endTime;
    return super.validPurchase() && withinCap;
    return super.hasEnded() || capReached;
        if(now <= preSalesEndDate && weiRaised < MAX_FUNDS_RAISED_DURING_PRESALE){
        if(now <= preSalesEndDate.add(PUBLIC_SALES_2_PERIOD_END)) {
        if(now <= preSalesEndDate.add(PUBLIC_SALES_1_PERIOD_END)) {
        if(now <= preSalesEndDate.add(PUBLIC_SALES_3_PERIOD_END)) {
