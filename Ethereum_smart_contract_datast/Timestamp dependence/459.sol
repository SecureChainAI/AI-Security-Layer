  require(_startTime >= now &&
            _endTime >= _startTime &&
            _airDropAmount > 0 &&
            _tokenAddress != address(0)
        );
bool validPeriod = now >= startTime && now <= endTime;
        return validNotStop && validAmount && validPeriod;
        bool validPeriod = now >= startTime && now <= endTime;
        require(stop || now > endTime);

