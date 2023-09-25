   function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
        private
    {
        // setup local rID
        uint256 _rID = rID_;
        
        // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
        if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
            roundClaimICOKeys(_rID);
        
        // if player is new to round and is owed keys from ICO phase 
        if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
        {
            // assign player their keys from ICO phase
            plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
            // zero out ICO phase investment
            plyrRnds_[_pID][_rID].ico = 0;
        }
            
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
        
        // manage airdrops
        if (_eth >= 100000000000000000)
        {
            airDropTracker_++;
            if (airdrop() == true)
            {
                // gib muni
                uint256 _prize;
                if (_eth >= 10000000000000000000) 
                {
                    // calculate prize and give it to winner
                    _prize = ((airDropPot_).mul(75)) / 100;
                    plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
                    
                    // adjust airDropPot 
                    airDropPot_ = (airDropPot_).sub(_prize);
                    
                    // let event know a tier 3 prize was won 
                    _eventData_.compressedData += 300000000000000000000000000000000;
                } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
                    // calculate prize and give it to winner
                    _prize = ((airDropPot_).mul(50)) / 100;
                    plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
                    
                    // adjust airDropPot 
                    airDropPot_ = (airDropPot_).sub(_prize);
                    
                    // let event know a tier 2 prize was won 
                    _eventData_.compressedData += 200000000000000000000000000000000;
                } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
                    // calculate prize and give it to winner
                    _prize = ((airDropPot_).mul(25)) / 100;
                    plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
                    
                    // adjust airDropPot 
                    airDropPot_ = (airDropPot_).sub(_prize);
                    
                    // let event know a tier 1 prize was won 
                    _eventData_.compressedData += 100000000000000000000000000000000;
                }
                // set airdrop happened bool to true
                _eventData_.compressedData += 10000000000000000000000000000000;
                // let event know how much was won 
                _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
                
                // reset air drop tracker
                airDropTracker_ = 0;
            }
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
