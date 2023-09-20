function distributeExternal(
    uint256 _rID,
    uint256 _pID,
    uint256 _eth,
    uint256 _affID,
    uint256 _team,
    POOHMODatasets.EventReturns memory _eventData_
) private returns (POOHMODatasets.EventReturns) {
    // pay 1% out to dev
    uint256 _dev = _eth / 100; // 1%

    uint256 _POOH = 0;
    if (!address(admin).call.value(_dev)()) {
        _POOH = _dev;
        _dev = 0;
    }

    // distribute share to affiliate
    uint256 _aff = _eth / 10;

    // decide what to do with affiliate share of fees
    // affiliate must not be self, and must have a name registered
    if (_affID != _pID && plyr_[_affID].name != "") {
        plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
        emit POOHMOevents.onAffiliatePayout(
            _affID,
            plyr_[_affID].addr,
            plyr_[_affID].name,
            _rID,
            _pID,
            _aff,
            now
        );
    } else {
        _POOH = _POOH.add(_aff);
    }

    // pay out POOH
    _POOH = _POOH.add((_eth.mul(fees_[_team].pooh)) / (100));
    if (_POOH > 0) {
        // deposit to divies contract
        //uint256 _potAmount = _POOH / 2;

        flushDivs.call.value(_POOH)(bytes4(keccak256("donate()")));

        //round_[_rID].pot = round_[_rID].pot.add(_potAmount);

        // set up event data
        _eventData_.POOHAmount = _POOH.add(_eventData_.POOHAmount);
    }

    return (_eventData_);
}
