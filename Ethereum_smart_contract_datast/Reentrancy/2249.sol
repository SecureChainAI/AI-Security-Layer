    function buyCore(uint256 _pID, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
        private
    {
        // grab time
        uint256 _now = now;
        
        // if round is active
        if (_now > round_.strt + rndGap_ && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))) 
        {
            // call core 
            core(_pID, msg.value, _affID, _eventData_);
        
        // if round is not active     
        } else {
            // check to see if end round needs to be ran
            if (_now > round_.end && round_.ended == false) 
            {
                // end the round (distributes pot) & start new round
                round_.ended = true;
                _eventData_ = endRound(_eventData_);
                
                // build event data
                _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
                _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
                
                // fire buy and distribute event 
                emit RSEvents.onBuyAndDistribute
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
                    _eventData_.genAmount
                );
            }
            
            // put eth in players vault 
            plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
        }
    }
   function core(uint256 _pID, uint256 _eth, uint256 _affID, RSdatasets.EventReturns memory _eventData_)
        private
    {
        // if player is new to round
        if (plyrRnds_[_pID].keys == 0)
            _eventData_ = managePlayer(_pID, _eventData_);
        
        // early round eth limiter 
        if (round_.eth < 100000000000000000000 && plyrRnds_[_pID].eth.add(_eth) > 10000000000000000000)
        {
            uint256 _availableLimit = (10000000000000000000).sub(plyrRnds_[_pID].eth);
            uint256 _refund = _eth.sub(_availableLimit);
            plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
            _eth = _availableLimit;
        }
        
        // if eth left is greater than min eth allowed (sorry no pocket lint)
        if (_eth > 1000000000) 
        {
            
            // mint the new keys
            uint256 _keys = (round_.eth).keysRec(_eth);
            
            // if they bought at least 1 whole key
            if (_keys >= 1000000000000000000)
            {
                updateTimer(_keys);

                // set new leaders
                if (round_.plyr != _pID)
                    round_.plyr = _pID;  
            
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
 function endRound(RSdatasets.EventReturns memory _eventData_)
        private
        returns (RSdatasets.EventReturns)
    {        
        // grab our winning player and team id's
        uint256 _winPID = round_.plyr;
        
        // grab our pot amount
        // add airdrop pot into the final pot
        uint256 _pot = round_.pot + airDropPot_;
        
        // calculate our winner share, community rewards, gen share, 
        // p3d share, and amount reserved for next pot 
        uint256 _win = (_pot.mul(45)) / 100;
        uint256 _com = (_pot / 10);
        uint256 _gen = (_pot.mul(potSplit_)) / 100;
        
        // calculate ppt for round mask
        uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
        uint256 _dust = _gen.sub((_ppt.mul(round_.keys)) / 1000000000000000000);
        if (_dust > 0)
        {
            _gen = _gen.sub(_dust);
            _com = _com.add(_dust);
        }
        
        // pay our winner
        plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
        
        // community rewards
        if (!address(RatKingCorp).call.value(_com)(bytes4(keccak256("deposit()"))))
        {
            _gen = _gen.add(_com);
            _com = 0;
        }
        
        // distribute gen portion to key holders
        round_.mask = _ppt.add(round_.mask);
            
        // prepare event data
        _eventData_.compressedData = _eventData_.compressedData + (round_.end * 1000000);
        _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
        _eventData_.winnerAddr = plyr_[_winPID].addr;
        _eventData_.winnerName = plyr_[_winPID].name;
        _eventData_.amountWon = _win;
        _eventData_.genAmount = _gen;
        _eventData_.newPot = 0;
        
        return(_eventData_);
    }
    
   function withdraw()
        isActivated()
        isHuman()
        public
    {        
        // grab time
        uint256 _now = now;
        
        // fetch player ID
        uint256 _pID = pIDxAddr_[msg.sender];
        
        // setup temp var for player eth
        uint256 _eth;
        
        // check to see if round has ended and no one has run round end yet
        if (_now > round_.end && round_.ended == false && round_.plyr != 0)
        {
            // set up our tx event data
            RSdatasets.EventReturns memory _eventData_;
            
            // end the round (distributes pot)
            round_.ended = true;
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
            emit RSEvents.onWithdrawAndDistribute
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
            emit RSEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
        }
    }
