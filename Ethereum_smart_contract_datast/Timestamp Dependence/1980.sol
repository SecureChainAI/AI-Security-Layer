function isUnderLimit(uint amount) internal returns (bool) {
    if (now > lastDay + 24 hours) {
        lastDay = now;
        spentToday = 0;
    }
    if (spentToday + amount > dailyLimit || spentToday + amount < spentToday)
        return false;
    return true;
}
