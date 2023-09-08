        require(now <= HOLDING_START); 
        require(now > HOLDING_START.add(5 minutes));
        if (num >= releasePercentages.length.sub(1)) {
