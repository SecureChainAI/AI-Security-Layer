        return teamTokensFreeze[_holder] == 0 || now >= teamTokensFreeze[_holder];
        return now >= startTime;
        return now >= endTime || isReachedLimit();
        if (capIsReached || (now >= endTime)) {
            if (capIsReached && now < endTime) {
