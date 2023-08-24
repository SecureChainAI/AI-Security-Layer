    function buyCore(uint256 _pID, uint256 _affID, uint256 _team, J3Ddatasets.EventReturns memory _eventData_)
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
            core(_rID, _pID, msg.value, _affID, _team, _eventData_);
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
                emit J3Devents.onBuyAndDistribute
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
                    _eventData_.P3DAmount, 
                    _eventData_.genAmount
                );
            }
            
            // put eth in players vault 
            plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
        }
    }

 function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, J3Ddatasets.EventReturns memory _eventData_)
        private
    {
    	//uint256 a = 1;
        // if player is new to round
        if (plyrRnds_[_pID][_rID].keys == 0)
            _eventData_ = managePlayer(_pID, _eventData_);
        
        // early round eth limiter 
        if (round_[_rID].eth < 50000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 2000000000000000000)
        {
            uint256 _availableLimit = (2000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
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

				if(janwin(round_[_rID].team,_team))
				{
					uint _janprice;
					if (_eth >= 10000000000000000000)
                	{
                    	// calculate prize and give it to winner
                    	_janprice = ((janPot_).mul(75)) / 100;
                    	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
                    
                    	// adjust airDropPot 
                    	janPot_ = (janPot_).sub(_janprice);
                    
                    	// let event know a tier 3 prize was won 
                    	//_eventData_.compressedData += 300000000000000000000000000000000;
                	} else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
                    	// calculate prize and give it to winner
                    	_janprice = ((janPot_).mul(50)) / 100;
                    	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
                    
                    	// adjust airDropPot 
                    	janPot_ = (janPot_).sub(_janprice);
                    
                    	// let event know a tier 2 prize was won 
                    	//_eventData_.compressedData += 200000000000000000000000000000000;
                	} else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
                    	// calculate prize and give it to winner
                    	_janprice = ((janPot_).mul(25)) / 100;
                    	plyr_[_pID].win = (plyr_[_pID].win).add(_janprice);
                    
                    	// adjust airDropPot 
                    	janPot_ = (janPot_).sub(_janprice);
                    
                    	// let event know a tier 3 prize was won 
                    	//_eventData_.compressedData += 300000000000000000000000000000000;
                	}
                	if(_janprice > 0){
                		// fired whenever an janwin is paid
    					 emit J3Devents.onNewJanWin(
    					 	_rID,
    					 	_pID,
    					 	plyr_[_pID].addr,
    					 	plyr_[_pID].name,
    					 	_janprice,
    					 	now
    					 );
                	}
                	    
                	
				}

            	// set new leaders
            	if (round_[_rID].plyr != _pID)
                	round_[_rID].plyr = _pID;  
            	if (round_[_rID].team != _team)
                	round_[_rID].team = _team; 
            
            	// set the new leader bool to true
            	_eventData_.compressedData = _eventData_.compressedData + 100;
        	}
        	

            // store the air drop tracker number (number of buys since last airdrop)
            //_eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
            
            // update player 
            plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
            plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
            
            // update round
            round_[_rID].keys = _keys.add(round_[_rID].keys);
            round_[_rID].eth = _eth.add(round_[_rID].eth);
            rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
    
            // distribute eth
            _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);

            _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
            
            // call end tx function to fire end tx event.
		    endTx(_pID, _team, _eth, _keys, _eventData_);
        }
    }

 function endRound(J3Ddatasets.EventReturns memory _eventData_)
        private
        returns (J3Ddatasets.EventReturns)
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
        uint256 _win = (_pot.mul(potSplit_[_winTID].win)) / 100;
        uint256 _com = (_pot.mul(potSplit_[_winTID].com)) / 100;
        uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
        //uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
        uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));//.sub(_p3d);
        
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
        
        if(janPot_ > 0){
        	_com = _com.add(janPot_);
        	janPot_ = 0;
        }
        
        // community rewards
        if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
        {
            // This ensures Team Just cannot influence the outcome of JKP with
            // bank migrations by breaking outgoing transactions.
            // Something we would never do. But that's not the point.
            // We spent 2000$ in eth re-deploying just to patch this, we hold the 
            // highest belief that everything we create should be trustless.
            // Team JUST, The name you shouldn't have to trust.
            //_p3d = _p3d.add(_com);
            _res = _res.add(_com);
            _com = 0;
        }
        
        // distribute gen portion to key holders
        round_[_rID].mask = _ppt.add(round_[_rID].mask);
        
        // send share for p3d to divies
        //if (_p3d > 0)
        //    Divies.deposit.value(_p3d)();
            
        // prepare event data
        _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
        _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
        _eventData_.winnerAddr = plyr_[_winPID].addr;
        _eventData_.winnerName = plyr_[_winPID].name;
        _eventData_.amountWon = _win;
        _eventData_.genAmount = _gen;
        //_eventData_.P3DAmount = _p3d;
        _eventData_.newPot = _res;
        
        // start next round
        rID_++;
        _rID++;
        round_[_rID].strt = now;
        round_[_rID].end = now.add(rndInit_).add(rndGap_);
        round_[_rID].pot = _res;
        
        return(_eventData_);
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
        if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
        {
            // set up our tx event data
            J3Ddatasets.EventReturns memory _eventData_;
            
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
            emit J3Devents.onWithdrawAndDistribute
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
            emit J3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
        }
    }
