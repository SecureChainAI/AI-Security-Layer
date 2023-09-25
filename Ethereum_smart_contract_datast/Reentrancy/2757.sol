  function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
        private
    {
        // check to see if round has ended.  and if player is new to round
        _eventData_ = manageRoundAndPlayer(_pID, _eventData_);

        // are we in ICO phase?
        if (now <= round_[rID_].strt + rndGap_)
        {
            // let event data know this is a ICO phase buy order
            _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;

            // ICO phase core
            icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);


        // round is live
        } else {
             // let event data know this is a buy order
            _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;

            // call core
            core(_pID, msg.value, _affID, _team, _eventData_);
        }
    }
    function endRound(F3Ddatasets.EventReturns memory _eventData_)
        private
        returns (F3Ddatasets.EventReturns)
    {
        // setup local rID
        uint256 _rID = rID_;

        // check to round ended with ONLY ico phase transactions
        if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
            roundClaimICOKeys(_rID);

        // grab our winning player and team id's
        uint256 _winPID = round_[_rID].plyr;
        uint256 _winTID = round_[_rID].team;

        // grab our pot amount
        uint256 _pot = round_[_rID].pot;

        // calculate our winner share, community rewards, gen share,
        // p3d share, and amount reserved for next pot
        uint256 _win = (_pot.mul(48)) / 100;
        uint256 _com = (_pot / 50);
        uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
        uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
        uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);

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
        if (!address(coin_base).call.value(_com)())
        {
            // This ensures Team Just cannot influence the outcome of FoMo3D with
            // bank migrations by breaking outgoing transactions.
            // Something we would never do. But that's not the point.
            // We spent 2000$ in eth re-deploying just to patch this, we hold the
            // highest belief that everything we create should be trustless.
            // Team JUST, The name you shouldn't have to trust.
            _p3d = _p3d.add(_com);
            _com = 0;
        }

        // distribute gen portion to key holders
        round_[_rID].mask = _ppt.add(round_[_rID].mask);

        // send share for p3d to divies
        if (_p3d > 0)
            coin_base.transfer(_p3d);

        // fill next round pot with its share
        round_[_rID + 1].pot += _res;

        // prepare event data
        _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
        _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
        _eventData_.winnerAddr = plyr_[_winPID].addr;
        _eventData_.winnerName = plyr_[_winPID].name;
        _eventData_.amountWon = _win;
        _eventData_.genAmount = _gen;
        _eventData_.P3DAmount = _p3d;
        _eventData_.newPot = _res;

        return(_eventData_);
    }
   function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
        private
    {
        // setup local rID
        uint256 _rID = rID_;

        // if they bought at least 1 whole key (at time of purchase)
        if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
        {
            // set new leaders
            if (round_[_rID].plyr != _pID)
                round_[_rID].plyr = _pID;
            if (round_[_rID].team != _team)
                round_[_rID].team = _team;

            // set the new leader bool to true
            _eventData_.compressedData = _eventData_.compressedData + 100;
        }

        // add eth to our players & rounds ICO phase investment. this will be used
        // to determine total keys and each players share
        plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
        round_[_rID].ico = _eth.add(round_[_rID].ico);

        // add eth in to team eth tracker
        rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);

        // send eth share to com, p3d, affiliate, and fomo3d long
        _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);

        // calculate gen share
        uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;

        // add gen share to rounds ICO phase gen tracker (will be distributed
        // when round starts)
        round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);

		// toss 1% into airdrop pot
        uint256 _air = (_eth / 100);
        airDropPot_ = airDropPot_.add(_air);

        // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
        uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);

        // add eth to pot
        round_[_rID].pot = _pot.add(round_[_rID].pot);

        // set up event data
        _eventData_.genAmount = _gen.add(_eventData_.genAmount);
        _eventData_.potAmount = _pot;

        // fire event
        endTx(_rID, _pID, _team, _eth, 0, _eventData_);
    }
   function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
        private
        returns (F3Ddatasets.EventReturns)
    {
        // setup local rID
        uint256 _rID = rID_;

        // grab time
        uint256 _now = now;

        // check to see if round has ended.  we use > instead of >= so that LAST
        // second snipe tx can extend the round.
        if (_now > round_[_rID].end)
        {
            // check to see if round end has been run yet.  (distributes pot)
            if (round_[_rID].ended == false)
            {
                _eventData_ = endRound(_eventData_);
                round_[_rID].ended = true;
            }

            // start next round in ICO phase
            rID_++;
            _rID++;
            round_[_rID].strt = _now;
            round_[_rID].end = _now.add(rndInit_).add(rndGap_);
        }

        // is player new to round?
        if (plyr_[_pID].lrnd != _rID)
        {
            // if player has played a previous round, move their unmasked earnings
            // from that round to gen vault.
            if (plyr_[_pID].lrnd != 0)
                updateGenVault(_pID, plyr_[_pID].lrnd);

            // update player's last round played
            plyr_[_pID].lrnd = _rID;

            // set the joined round bool to true
            _eventData_.compressedData = _eventData_.compressedData + 10;
        }

        return(_eventData_);
    }
    function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
        private
    {
        // check to see if round has ended.  and if player is new to round
        _eventData_ = manageRoundAndPlayer(_pID, _eventData_);

        // get earnings from all vaults and return unused to gen vault
        // because we use a custom safemath library.  this will throw if player
        // tried to spend more eth than they have.
        plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);

        // are we in ICO phase?
        if (now <= round_[rID_].strt + rndGap_)
        {
            // let event data know this is an ICO phase reload
            _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;

            // ICO phase core
            icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);


        // round is live
        } else {
            // call core
            core(_pID, _eth, _affID, _team, _eventData_);
        }
    }
   function withdraw()
        isActivated()
        isHuman()
        public
    {
        // setup local rID
        uint256 _rID = rID_;

        // grab time
        uint256 _now = now;

        // fetch player ID
        uint256 _pID = pIDxAddr_[msg.sender];

        // setup temp var for player eth
        uint256 _eth;

        // check to see if round has ended and no one has run round end yet
        if (_now > round_[_rID].end && round_[_rID].ended == false)
        {
            // set up our tx event data
            F3Ddatasets.EventReturns memory _eventData_;

            // end the round (distributes pot)
			round_[_rID].ended = true;
            _eventData_ = endRound(_eventData_);

			// get their earnings
            _eth = withdrawEarnings(_pID);

            // gib moni
            if (_eth > 0)
                plyr_[_pID].addr.transfer(_eth);

            // build event data
            _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
            _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;

            // fire withdraw and distribute event
            emit F3Devents.onWithdrawAndDistribute
            (
                msg.sender,
                plyr_[_pID].name,
                _eth,
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
            // get their earnings
            _eth = withdrawEarnings(_pID);

            // gib moni
            if (_eth > 0)
                plyr_[_pID].addr.transfer(_eth);

            // fire withdraw event
            emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
        }
    }
