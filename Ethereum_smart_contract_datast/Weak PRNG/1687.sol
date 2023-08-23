function validPurchaseTime(
    uint256 _currentTime
) public view canMint returns (bool) {
    uint256 dayTime = _currentTime % 1 days;
    if (startTimeDay <= dayTime && dayTime <= endTimeDay) {
        return true;
    }
    return false;
}
