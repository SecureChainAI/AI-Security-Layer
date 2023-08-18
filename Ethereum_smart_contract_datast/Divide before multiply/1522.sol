function updateTimer(uint256 _keys, uint256 _rID) private {
    // grab time
    uint256 _now = now;

    // calculate time based on number of keys bought
    uint256 _newTime;
    if (_now > round_[_rID].end && round_[_rID].plyr == 0)
        _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
    else
        _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(
            round_[_rID].end
        );

    // compare to max and set new end time
    if (_newTime < (rndMax_).add(_now)) round_[_rID].end = _newTime;
    else round_[_rID].end = rndMax_.add(_now);
}
