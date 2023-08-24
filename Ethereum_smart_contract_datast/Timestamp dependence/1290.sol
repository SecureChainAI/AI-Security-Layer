    bool withinPeriod = now >= startTime && now <= endTime;
    return nonZeroPurchase && withinPeriod;
      bool timeEnded = now > endTime;
