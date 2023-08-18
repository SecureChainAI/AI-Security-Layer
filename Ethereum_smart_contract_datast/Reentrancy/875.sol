function withdraw() public isActivated isHuman {
    // setup local rID

    // grab time
    uint256 _now = now;

    // fetch player ID
    uint256 _pID = pIDxAddr_[msg.sender];

    // setup temp var for player eth
    uint256 upperLimit = 0;
    uint256 usedGen = 0;

    // eth send to player
    uint256 ethout = 0;

    // 超限收益
    uint256 over_gen = 0;

    // update gen vault
    updateGenVault(_pID, plyr_[_pID].lrnd);

    // 当前现存收益
    // 先触发限收检测和处理
    if (plyr_[_pID].gen > 0) {
        upperLimit = (calceth(plyrRnds_[_pID][rID_].keys).mul(105)) / 100;
        if (plyr_[_pID].gen >= upperLimit) {
            // 超限收益部分
            over_gen = (plyr_[_pID].gen).sub(upperLimit);
            // keys清零
            round_[rID_].keys = (round_[rID_].keys).sub(
                plyrRnds_[_pID][rID_].keys
            );
            plyrRnds_[_pID][rID_].keys = 0;

            // 超出部分转交admin
            admin.transfer(over_gen);

            //可用gen
            usedGen = upperLimit;
        } else {
            // keys一部分清减，对应全部gen的量
            plyrRnds_[_pID][rID_].keys = (plyrRnds_[_pID][rID_].keys).sub(
                calckeys(((plyr_[_pID].gen).mul(100)) / 105)
            );
            round_[rID_].keys = (round_[rID_].keys).sub(
                calckeys(((plyr_[_pID].gen).mul(100)) / 105)
            );
            //可用gen
            usedGen = plyr_[_pID].gen;
        }

        ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff)).add(usedGen);
    } else {
        ethout = ((plyr_[_pID].win).add(plyr_[_pID].aff));
    }

    plyr_[_pID].win = 0;
    plyr_[_pID].gen = 0;
    plyr_[_pID].aff = 0;

    plyr_[_pID].addr.transfer(ethout);

    // check to see if round has ended and no one has run round end yet
    if (
        _now > round_[rID_].end &&
        round_[rID_].ended == false &&
        round_[rID_].plyr != 0
    ) {
        // set up our tx event data
        SPCdatasets.EventReturns memory _eventData_;

        // end the round (distributes pot)
        round_[rID_].ended = true;
        _eventData_ = endRound(_eventData_);

        // build event data
        _eventData_.compressedData =
            _eventData_.compressedData +
            (_now * 1000000000000000000);
        _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;

        // fire withdraw and distribute event
        emit SPCevents.onWithdrawAndDistribute(
            msg.sender,
            plyr_[_pID].name,
            ethout,
            _eventData_.compressedData,
            _eventData_.compressedIDs,
            _eventData_.winnerAddr,
            _eventData_.winnerName,
            _eventData_.amountWon,
            _eventData_.newPot,
            _eventData_.P3DAmount,
            _eventData_.genAmount
        );

        // in any other situation
    } else {
        // fire withdraw event
        emit SPCevents.onWithdraw(
            _pID,
            msg.sender,
            plyr_[_pID].name,
            ethout,
            _now
        );
    }
}
