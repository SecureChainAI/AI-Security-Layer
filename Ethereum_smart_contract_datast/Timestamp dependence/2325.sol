    require(_startTime >= now);
    bool withinPeriod = now >= startTime && now <= endTime;
    return withinPeriod && nonZeroPurchase;
    return now > endTime;
    require(_startTime >= block.timestamp);
   } else if (
      block.timestamp >= startTime &&
      block.timestamp < startOpenPpTime &&
      crowdsaleState != state.priorityPass
    ) {
 } else if (
      block.timestamp >= startOpenPpTime &&
      block.timestamp <= endTime &&
      crowdsaleState != state.crowdsale
    ) {
      emit DipTgeStarted(block.timestamp);
  } else if (
      crowdsaleState != state.crowdsaleEnded &&
      block.timestamp > endTime
    ) {
    if (block.timestamp < lockInTime1 && contributorList[_contributor].lockupPeriod == 1) {
    } else if (block.timestamp < lockInTime2 && contributorList[_contributor].lockupPeriod == 2) {
