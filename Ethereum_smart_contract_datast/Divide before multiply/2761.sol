function updateTimer(uint256 _keys, uint256 _rID) private {
    // grab time
    uint256 _now = now;
    // if (round_[_rID].end.sub(_now) <= (60 seconds) && hasPlayersInRound(_rID) == true) {
    //     return;
    // }

    // calculate time based on number of keys bought
    uint256 _newTime;
    if (_now > round_[_rID].end && hasPlayersInRound(_rID) == false)
        _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
    else
        _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(
            round_[_rID].end
        );

    // rndSubed_ 根据资金量扣减时间
    uint256 _rndEth = round_[_rID].eth; // 本轮eth总量
    uint256 _rndNeedSub = 0; // 本轮最大时间需减少的时间
    if (_rndEth >= (2000 ether)) {
        if (_rndEth <= (46000 ether)) {
            // sub hours
            _rndNeedSub = (1 hours).mul(_rndEth / (2000 ether));
        } else {
            _rndNeedSub = (1 hours).mul(23);
            uint256 _ethLeft = _rndEth.sub(46000 ether);
            if (_ethLeft <= (12000 ether)) {
                _rndNeedSub = _rndNeedSub.add(
                    (590 seconds).mul(_ethLeft / (2000 ether))
                );
            } else {
                // 最后一分钟
                _rndNeedSub = 999;
            }
        }
    }

    if (_rndNeedSub != 999) {
        uint256 _rndMax = rndMax_.sub(_rndNeedSub);
        // compare to max and set new end time
        if (_newTime < (_rndMax).add(_now)) round_[_rID].end = _newTime;
        else round_[_rID].end = _rndMax.add(_now);
    }
}
