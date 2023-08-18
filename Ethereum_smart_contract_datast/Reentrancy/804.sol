function transfer(address _to, uint256 _value) public returns (bool success) {
    require(!paused);
    require(msg.sender != cfoAddress);
    require(msg.sender != _to);

    //先判断是否有可以解禁
    if (_balancesMap[msg.sender].unlockLeft > 0) {
        UserToken storage sender = _balancesMap[msg.sender];
        uint256 diff = now.sub(sender.unlockLastTime);
        uint256 round = diff.div(sender.unlockPeriod);
        if (round > 0) {
            uint256 unlocked = sender.unlockUnit.mul(round);
            if (unlocked > sender.unlockLeft) {
                unlocked = sender.unlockLeft;
            }

            sender.unlockLeft = sender.unlockLeft.sub(unlocked);
            sender.tokens = sender.tokens.add(unlocked);
            sender.unlockLastTime = sender.unlockLastTime.add(
                sender.unlockPeriod.mul(round)
            );

            emit Unlock(msg.sender, unlocked);
            log(actionUnlock, msg.sender, 0, unlocked, 0, 0);
        }
    }

    require(_balancesMap[msg.sender].tokens >= _value);
    _balancesMap[msg.sender].tokens = _balancesMap[msg.sender].tokens.sub(
        _value
    );

    uint index = _balancesMap[_to].index;
    if (index == 0) {
        UserToken memory user;
        user.index = _balancesArray.length;
        user.addr = _to;
        user.tokens = _value;
        user.unlockUnit = 0;
        user.unlockPeriod = 0;
        user.unlockLeft = 0;
        user.unlockLastTime = 0;
        _balancesMap[_to] = user;
        _balancesArray.push(_to);
    } else {
        _balancesMap[_to].tokens = _balancesMap[_to].tokens.add(_value);
    }

    emit Transfer(msg.sender, _to, _value);
    log(actionTransfer, msg.sender, _to, _value, 0, 0);
    success = true;
}
