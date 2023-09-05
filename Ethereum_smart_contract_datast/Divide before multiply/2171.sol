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

function updateMasks(
    uint256 _rID,
    uint256 _pID,
    uint256 _gen,
    uint256 _keys
) private returns (uint256) {
    /* MASKING NOTES
            earnings masks are a tricky thing for people to wrap their minds around.
            the basic thing to understand here.  is were going to have a global
            tracker based on profit per share for each round, that increases in
            relevant proportion to the increase in share supply.
            
            the player will have an additional mask that basically says "based
            on the rounds mask, my shares, and how much i've already withdrawn,
            how much is still owed to me?"
        */

    // calc profit per key & round mask based on this buy:  (dust goes to pot)
    uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
    round_[_rID].mask = _ppt.add(round_[_rID].mask);

    // calculate player earning from their own buy (only based on the keys
    // they just bought).  & update player earnings mask
    uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
    plyrRnds_[_pID][_rID].mask = (
        ((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)
    ).add(plyrRnds_[_pID][_rID].mask);

    // calculate & return dust
    return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
}
