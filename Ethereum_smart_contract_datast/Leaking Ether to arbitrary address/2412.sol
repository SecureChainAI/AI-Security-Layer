function endRound(
    BATMODatasets.EventReturns memory _eventData_
) private returns (BATMODatasets.EventReturns) {
    // setup local rID
    uint256 _rID = rID_;

    // grab our winning player and team id's
    uint256 _winPID = round_[_rID].plyr;
    uint256 _winTID = round_[_rID].team;

    // grab our pot amount
    uint256 _pot = round_[_rID].pot;

    // calculate our winner share, community rewards, gen share,
    // tokenholder share, and amount reserved for next pot
    uint256 _win = (_pot.mul(48)) / 100; //48%
    uint256 _dev = (_pot / 50); //2%
    uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
    uint256 _OBOK = (_pot.mul(potSplit_[_winTID].obok)) / 100;
    uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_OBOK);

    // calculate ppt for round mask
    uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
    uint256 _dust = _gen.sub(
        (_ppt.mul(round_[_rID].keys)) / 1000000000000000000
    );
    if (_dust > 0) {
        _gen = _gen.sub(_dust);
        _res = _res.add(_dust);
    }

    // pay our winner
    plyr_[_winPID].win = _win.add(plyr_[_winPID].win);

    // community rewards

    admin.transfer(_dev / 2);
    admin2.transfer(_dev / 2);

    address(ObokContract).call.value(_OBOK.sub((_OBOK / 3).mul(2)))(
        bytes4(keccak256("donateDivs()"))
    ); //66%

    round_[_rID].pot = _pot.add(_OBOK / 3); // 33%

    // distribute gen portion to key holders
    round_[_rID].mask = _ppt.add(round_[_rID].mask);

    // prepare event data
    _eventData_.compressedData =
        _eventData_.compressedData +
        (round_[_rID].end * 1000000);
    _eventData_.compressedIDs =
        _eventData_.compressedIDs +
        (_winPID * 100000000000000000000000000) +
        (_winTID * 100000000000000000);
    _eventData_.winnerAddr = plyr_[_winPID].addr;
    _eventData_.winnerName = plyr_[_winPID].name;
    _eventData_.amountWon = _win;
    _eventData_.genAmount = _gen;
    _eventData_.tokenAmount = _OBOK;
    _eventData_.newPot = _res;

    // start next round
    rID_++;
    _rID++;
    round_[_rID].strt = now;
    round_[_rID].end = now.add(rndInit_).add(rndGap_);
    round_[_rID].pot += _res;

    return (_eventData_);
}
