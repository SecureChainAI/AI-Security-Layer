        require(now >= group.releaseTimestamp);
        require(now >= startTime && now < endTime);
        return now >= endTime;
