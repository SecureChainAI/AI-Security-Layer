            bool timeInBound = (timeStartsBoundaries[i] <= now) && (now < timeEndsBoundaries[i]);
    bool withinPeriod = now >= startTime && now <= endTime;
    return nonZeroPurchase && withinPeriod;
      bool timeEnded = now > endTime;
