        temp = (round_[_rIDlast].mask).mul((plyrRnds_[_pID][_rIDlast].keys)/1000000000000000000);
        uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
        uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
        uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
            _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
            _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
        uint256 _p3d = (_eth/100).mul(3);
        uint256 _aff_cent = (_eth) / 100;
            _p3d = _p3d.add(_aff_cent.mul(5));
            plyr_[tempID].aff = (_aff_cent.mul(3)).add(plyr_[tempID].aff);
            _p3d = _p3d.add(_aff_cent.mul(3));
            emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(3), now);
            plyr_[tempID].aff = (_aff_cent.mul(2)).add(plyr_[tempID].aff);
            _p3d = _p3d.add(_aff_cent.mul(2));
            emit SPCevents.onAffiliatePayout(tempID, plyr_[tempID].addr, plyr_[tempID].name, _rID, _pID, _aff_cent.mul(2), now);
        uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
        uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
        return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
