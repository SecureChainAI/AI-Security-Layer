      require(now < timeLock || timeLock == 0);
      require(now < timeLock || timeLock == 0);
      require(now < timeLock || timeLock == 0);
      require(now < timeLock || timeLock == 0);
      require(now < timeLock || timeLock == 0);
        require(now > advisor[msg.sender].advisorTimeLock);
        require(now > backer[msg.sender].backerTimeLock);
        if (now > foundation[msg.sender].foundationTimeLock) {
        require(now > founder[msg.sender].founderTimeLock);
        if (now > privatePurchaser[msg.sender].privatePurchaserTimeLock) {
