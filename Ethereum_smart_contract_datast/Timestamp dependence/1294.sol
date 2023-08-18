        require((timeLocks[_to].amount.sub(timeLocks[_to].vestedAmount) == 0), "The previous vesting should be completed.");
        require(_amount <= balances[msg.sender], "Not enough balance to grant token.");
 require(_cliff >= _start, "_cliff must be >= _start");
        require(_vesting > _start, "_vesting must be bigger than _start");
        require(_vesting > _cliff, "_vesting must be bigger than _cliff");
        if (curTime <= timeLocks[_to].cliff) {
        require(timeLocks[_to].amount > 0, "Nothing was granted to this address.");
        if (curTime >= timeLocks[_to].vesting) {
        if (vestedMonths > 0) {
            if (vestedAmount > timeLocks[_to].amount) {
 require(timeLocks[_to].amount > 0, "Nothing was granted to this address!");
        require(timeLocks[_to].vestedAmount < timeLocks[_to].amount, "All tokens were vested!");
        require(amount > 0, "Nothing to redeem now.");
        require(to != address(0));
        require(timeLocks[msg.sender].amount > 0, "Nothing to return.");
        require(_amount <= timeLocks[msg.sender].amount.sub(timeLocks[msg.sender].vestedAmount), "Not enough granted token to return.");
