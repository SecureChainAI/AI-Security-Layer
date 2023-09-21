        require(now < endTime);
        require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
        require(now >= startTime && now <= endTime, "Offering is closed/Not yet started");
