		require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
        require(now < time, "Time must be in the future");
            if (time > now) {
        require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender), "Value to transfer exceeds available havvens");
        require(nominsIssued[from] == 0 || value <= transferableHavvens(from), "Value to transfer exceeds available havvens");
        if (lastTotalIssued > 0) {
        if (issuanceData[account].lastModified < feePeriodStartTime) {
if (lastModified < feePeriodStartTime) {
        require(amount <= remainingIssuableNomins(sender), "Amount must be less than or equal to remaining issuable nomins");
        if (now >= feePeriodStartTime + feePeriodDuration) {
        if (issued > max) {
        if (issued == 0) {
        if (debt > collat) {
        if (draft > collat) {
        if (draft > safeSub(collat, bal)) {
            if (lastModified < lastFeePeriodStartTime) { require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT,
            "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
        return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
 require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT, 
            "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
        return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
