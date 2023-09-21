        require(now + _forTime * 1 hours >= depositLock[msg.sender]);
        if (now > depositLock[msg.sender]) {
        depositLock[_to] = depositLock[_to] > now ? depositLock[_to] : now + 1 hours;
