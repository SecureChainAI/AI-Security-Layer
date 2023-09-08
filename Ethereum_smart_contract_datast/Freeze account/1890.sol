  function freeze(address user, uint amount, uint period) public onlyOwner {
        require(balances[user] >= amount);
        freezed[user] = true;
        unlockTime[user] = uint(now) + period;
        freezeAmount[user] = amount;
    }