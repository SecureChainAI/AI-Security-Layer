 function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, SPCdatasets.EventReturns memory _eventData_)
        private
    {
        // if player is new to round。
        if (plyrRnds_[_pID][_rID].jionflag != 1)
        {
          _eventData_ = managePlayer(_pID, _eventData_);
          plyrRnds_[_pID][_rID].jionflag = 1;

          attend[round_[_rID].attendNum] = _pID;
          round_[_rID].attendNum  = (round_[_rID].attendNum).add(1);
        }

        if (_eth > 10000000000000000)
        {

            // mint the new keys
            uint256 _keys = calckeys(_eth);

            // if they bought at least 1 whole key
            if (_keys >= 1000000000000000000)
            {
              updateTimer(_keys, _rID);

              // set new leaders
              if (round_[_rID].plyr != _pID)
                round_[_rID].plyr = _pID;

              round_[_rID].team = 2;

              // set the new leader bool to true
              _eventData_.compressedData = _eventData_.compressedData + 100;
            }

            // update player
            plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
            plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);

            // update round
            round_[_rID].keys = _keys.add(round_[_rID].keys);
            round_[_rID].eth = _eth.add(round_[_rID].eth);
            rndTmEth_[_rID][2] = _eth.add(rndTmEth_[_rID][2]);

            // distribute eth
            _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, 2, _eventData_);
            _eventData_ = distributeInternal(_rID, _pID, _eth, 2, _keys, _eventData_);

            // call end tx function to fire end tx event.
            endTx(_pID, 2, _eth, _keys, _eventData_);
        }
    }