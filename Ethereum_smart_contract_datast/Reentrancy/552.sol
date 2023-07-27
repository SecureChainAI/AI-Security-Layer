 function buyCore(uint256 _pID, uint256 _affID, ZaynixKeyDatasets.EventReturns memory _eventData_)
        private
    {
        // setup local rID
        uint256 _rID = rID_;

        // grab time
        uint256 _now = now;

        // if round is active
        if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
        {
            // call core
            core(_rID, _pID, msg.value, _affID, 0, _eventData_);

        // if round is not active
        } else {
            // check to see if end round needs to be ran
            if (_now > round_[_rID].end && round_[_rID].ended == false)
            {
                // end the round (distributes pot) & start new round
                round_[_rID].ended = true;
                _eventData_ = endRound(_eventData_);

                // build event data
                _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
                _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;

                // fire buy and distribute event
                emit ZaynixKeyevents.onBuyAndDistribute
                (
                    msg.sender,
                    plyr_[_pID].name,
                    msg.value,
                    _eventData_.compressedData,
                    _eventData_.compressedIDs,
                    _eventData_.winnerAddr,
                    _eventData_.winnerName,
                    _eventData_.amountWon,
                    _eventData_.newPot,
                    _eventData_.ZaynixKeyAmount,
                    _eventData_.genAmount
                );
            }

            // put eth in players vault
            plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
        }
    } function endRound(ZaynixKeyDatasets.EventReturns memory _eventData_)
        private
        returns (ZaynixKeyDatasets.EventReturns)
    {
        // setup local rID
        uint256 _rID = rID_;

        // grab our winning player and team id's
        uint256 _winPID = round_[_rID].plyr;
        uint256 _winTID = round_[_rID].team;

        // grab our pot amount
        uint256 _pot = round_[_rID].pot;

        // calculate our winner share, community rewards, gen share,
        // p3d share, and amount reserved for next pot
        uint256 _win = (_pot.mul(48)) / 100;   //48%
        uint256 _dev = (_pot / 50);            //2%
        uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100; //15
        uint256 _ZaynixKey = (_pot.mul(potSplit_[_winTID].ZaynixKey)) / 100; // 10
        uint256 _res = (((_pot.sub(_win)).sub(_dev)).sub(_gen)).sub(_ZaynixKey); //25

        // calculate ppt for round mask
        uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
        uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
        if (_dust > 0)
        {
            _gen = _gen.sub(_dust);
            _res = _res.add(_dust);
        }

        // pay our winner
        plyr_[_winPID].win = _win.add(plyr_[_winPID].win);

        // community rewards

        admin.transfer(_dev);

        flushDivs.call.value(_ZaynixKey)(bytes4(keccak256("donate()")));  

        // distribute gen portion to key holders
        round_[_rID].mask = _ppt.add(round_[_rID].mask);

        // prepare event data
        _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
        _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
        _eventData_.winnerAddr = plyr_[_winPID].addr;
        _eventData_.winnerName = plyr_[_winPID].name;
        _eventData_.amountWon = _win;
        _eventData_.genAmount = _gen;
        _eventData_.ZaynixKeyAmount = _ZaynixKey;
        _eventData_.newPot = _res;

        // start next round
        rID_++;
        _rID++;
        round_[_rID].strt = now;
        rndMax_ = timerLengths[determineNextRoundLength()];
        round_[_rID].end = now.add(rndMax_);
        round_[_rID].pot = _res;

        return(_eventData_);
    }
      function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, ZaynixKeyDatasets.EventReturns memory _eventData_)
        private
    {
        // if player is new to round
        if (plyrRnds_[_pID][_rID].keys == 0)
            _eventData_ = managePlayer(_pID, _eventData_);

        // early round eth limiter
        if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
        {
            uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
            uint256 _refund = _eth.sub(_availableLimit);
            plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
            _eth = _availableLimit;
        }

        // if eth left is greater than min eth allowed (sorry no pocket lint)
        if (_eth > 1000000000)
        {

            // mint the new keys
            uint256 _keys = (round_[_rID].eth).keysRec(_eth);

            // if they bought at least 1 whole key
            if (_keys >= 1000000000000000000)
            {
            updateTimer(_keys, _rID);

            // set new leaders
            if (round_[_rID].plyr != _pID)
                round_[_rID].plyr = _pID;
            if (round_[_rID].team != _team)
                round_[_rID].team = _team;

            // set the new leader bool to true
            _eventData_.compressedData = _eventData_.compressedData + 100;
        }

            // update player
            plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
            plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);

            // update round
            round_[_rID].keys = _keys.add(round_[_rID].keys);
            round_[_rID].eth = _eth.add(round_[_rID].eth);
            rndTmEth_[_rID][0] = _eth.add(rndTmEth_[_rID][0]);

            // distribute eth
            _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 0, _eventData_);
            _eventData_ = distributeInternal(_rID, _pID, _eth, 0, _keys, _eventData_);

            // call end tx function to fire end tx event.
            endTx(_pID, 0, _eth, _keys, _eventData_);
        }
    }