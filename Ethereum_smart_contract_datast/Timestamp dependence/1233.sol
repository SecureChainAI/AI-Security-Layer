    require(_startTime >= now);
    return now > endTime || weiRaised >= cap;
    return now > startTime;
    return withinCap && withinPeriod();
    return now >= startTime && now <= endTime;
        require(grants[_to].value == 0);
        require(totalVesting.add(_value.sub(prevested)) <= token.balanceOf(address(this)));
        if (grant.value == 0) {
        if (_time < _grant.cliff) {
        if (_time >= _grant.end) {
        require(grant.value != 0);
        if (transferable == 0) {
    if (!tiersInitialized || !Presale.hasStarted()) return Stage.Preparing;
    if (Presale.hasEnded() && !hasStarted()) return Stage.PresaleFinished;
    require(_startTime >= now);
    return now > endTime || weiRaised >= cap;
    return publicSaleInitialized && now >= startTime;
