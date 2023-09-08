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
