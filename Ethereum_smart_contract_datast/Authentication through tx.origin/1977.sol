   modifier isHuman() {
        address _addr = msg.sender;
        require (_addr == tx.origin);
        
        uint256 _codeLength;
        
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0, "sorry humans only");
        _;
    }
   function()
        isActivated()
        isHuman()
        isWithinLimits(msg.value)
        public
        payable
    {
        // set up our tx event data and determine if player is new or not
        F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);

        // fetch player id
        uint256 _pID = pIDxAddr_[msg.sender];

        // buy core
        buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
    }

    /**
     * @dev converts all incoming ethereum to keys.
     * -functionhash- 0x8f38f309 (using ID for affiliate)
     * -functionhash- 0x98a0871d (using address for affiliate)
     * -functionhash- 0xa65b37a1 (using name for affiliate)
     * @param _affCode the ID/address/name of the player who gets the affiliate fee
     * @param _team what team is the player playing for?
     */
    function buyXid(uint256 _affCode, uint256 _team)
        isActivated()
        isHuman()
        isWithinLimits(msg.value)
        public
        payable
    {
        // set up our tx event data and determine if player is new or not
        F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);

        // fetch player id
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == 0 || _affCode == _pID)
        {
            // use last stored affiliate code
            _affCode = plyr_[_pID].laff;

        // if affiliate code was given & its not the same as previously stored
        } else if (_affCode != plyr_[_pID].laff) {
            // update last affiliate
            plyr_[_pID].laff = _affCode;
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // buy core
        buyCore(_pID, _affCode, _team, _eventData_);
    }

    function buyXaddr(address _affCode, uint256 _team)
        isActivated()
        isHuman()
        isWithinLimits(msg.value)
        public
        payable
    {
        // set up our tx event data and determine if player is new or not
        F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);

        // fetch player id
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        uint256 _affID;
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == address(0) || _affCode == msg.sender)
        {
            // use last stored affiliate code
            _affID = plyr_[_pID].laff;

        // if affiliate code was given
        } else {
            // get affiliate ID from aff Code
            _affID = pIDxAddr_[_affCode];

            // if affID is not the same as previously stored
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // buy core
        buyCore(_pID, _affID, _team, _eventData_);
    }

    function buyXname(bytes32 _affCode, uint256 _team)
        isActivated()
        isHuman()
        isWithinLimits(msg.value)
        public
        payable
    {
        // set up our tx event data and determine if player is new or not
        F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);

        // fetch player id
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        uint256 _affID;
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == '' || _affCode == plyr_[_pID].name)
        {
            // use last stored affiliate code
            _affID = plyr_[_pID].laff;

        // if affiliate code was given
        } else {
            // get affiliate ID from aff Code
            _affID = pIDxName_[_affCode];

            // if affID is not the same as previously stored
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // buy core
        buyCore(_pID, _affID, _team, _eventData_);
    }

    /**
     * @dev essentially the same as buy, but instead of you sending ether
     * from your wallet, it uses your unwithdrawn earnings.
     * -functionhash- 0x349cdcac (using ID for affiliate)
     * -functionhash- 0x82bfc739 (using address for affiliate)
     * -functionhash- 0x079ce327 (using name for affiliate)
     * @param _affCode the ID/address/name of the player who gets the affiliate fee
     * @param _team what team is the player playing for?
     * @param _eth amount of earnings to use (remainder returned to gen vault)
     */
    function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
        isActivated()
        isHuman()
        isWithinLimits(_eth)
        public
    {
        // set up our tx event data
        F3Ddatasets.EventReturns memory _eventData_;

        // fetch player ID
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == 0 || _affCode == _pID)
        {
            // use last stored affiliate code
            _affCode = plyr_[_pID].laff;

        // if affiliate code was given & its not the same as previously stored
        } else if (_affCode != plyr_[_pID].laff) {
            // update last affiliate
            plyr_[_pID].laff = _affCode;
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // reload core
        reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
    }

    function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
        isActivated()
        isHuman()
        isWithinLimits(_eth)
        public
    {
        // set up our tx event data
        F3Ddatasets.EventReturns memory _eventData_;

        // fetch player ID
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        uint256 _affID;
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == address(0) || _affCode == msg.sender)
        {
            // use last stored affiliate code
            _affID = plyr_[_pID].laff;

        // if affiliate code was given
        } else {
            // get affiliate ID from aff Code
            _affID = pIDxAddr_[_affCode];

            // if affID is not the same as previously stored
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // reload core
        reLoadCore(_pID, _affID, _team, _eth, _eventData_);
    }

    function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
        isActivated()
        isHuman()
        isWithinLimits(_eth)
        public
    {
        // set up our tx event data
        F3Ddatasets.EventReturns memory _eventData_;

        // fetch player ID
        uint256 _pID = pIDxAddr_[msg.sender];

        // manage affiliate residuals
        uint256 _affID;
        // if no affiliate code was given or player tried to use their own, lolz
        if (_affCode == '' || _affCode == plyr_[_pID].name)
        {
            // use last stored affiliate code
            _affID = plyr_[_pID].laff;

        // if affiliate code was given
        } else {
            // get affiliate ID from aff Code
            _affID = pIDxName_[_affCode];

            // if affID is not the same as previously stored
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }

        // verify a valid team was selected
        _team = verifyTeam(_team);

        // reload core
        reLoadCore(_pID, _affID, _team, _eth, _eventData_);
    }

    /**
     * @dev withdraws all of your earnings.
     * -functionhash- 0x3ccfd60b
     */
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

   
    function registerNameXID(string _nameString, uint256 _affCode, bool _all)
        isHuman()
        public
        payable
    {
        bytes32 _name = _nameString.nameFilter();
        address _addr = msg.sender;
        uint256 _paid = msg.value;
        (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);

        uint256 _pID = pIDxAddr_[_addr];

        // fire event
        emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
    }

    function registerNameXaddr(string _nameString, address _affCode, bool _all)
        isHuman()
        public
        payable
    {
        bytes32 _name = _nameString.nameFilter();
        address _addr = msg.sender;
        uint256 _paid = msg.value;
        (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);

        uint256 _pID = pIDxAddr_[_addr];

        // fire event
        emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
    }

    function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
        isHuman()
        public
        payable
    {
        bytes32 _name = _nameString.nameFilter();
        address _addr = msg.sender;
        uint256 _paid = msg.value;
        (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);

        uint256 _pID = pIDxAddr_[_addr];

        // fire event
        emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
    }