function isTransferAllowed(address _user) internal view returns (bool) {
    bool retVal = true;
    if (vestingUsers[_user] == USER_FOUNDER) {
        if (
            endSaleTime == 0 || // See whether sale is over?
            (now < (endSaleTime + 730 days))
        )
            // 2 years
            retVal = false;
    } else if (
        vestingUsers[_user] == USER_BUYER || vestingUsers[_user] == USER_BONUS
    ) {
        if (
            startTimeOfSaleLot4 == 0 || // See if the SaleLot4 started?
            (now < (startTimeOfSaleLot4 + 90 days))
        ) retVal = false;
    }
    return retVal;
}
