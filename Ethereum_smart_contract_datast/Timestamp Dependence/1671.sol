function resumeTokenSale() public onlyAdmin {
    // confirm the token sale is currently paused
    require(tokenSaleIsPaused == true);

    tokenSaleResumedTime = now;

    // now calculate the difference in time between the pause time
    // and the resume time, to establish how long the sale was
    // paused for. This time now needs to be added to the closingTime.

    // Note: if the token sale was paused whilst the sale was live and was
    // paused before the sale ended, then the value of tokenSalePausedTime
    // will always be less than the value of tokenSaleResumedTime

    tokenSalePausedDuration = tokenSaleResumedTime.sub(tokenSalePausedTime);

    // add the total pause time to the closing time.

    closingTime = closingTime.add(tokenSalePausedDuration);

    // extend post ICO countdown for the web-site
    postIcoPhaseCountdown = closingTime.add(14 days);
    // now resume the token sale
    tokenSaleIsPaused = false;
    emit SaleResumed("token sale has now resumed", now);
}
