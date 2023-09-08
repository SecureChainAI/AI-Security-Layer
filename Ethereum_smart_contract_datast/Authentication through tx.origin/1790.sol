 modifier isHuman() {
        address _addr = msg.sender;
        uint256 _codeLength;
        
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0);
        require(_addr == tx.origin);
        _;
    }
function registerNameXID(string _nameString, uint256 _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        // make sure name fees paid
        require (msg.value >= registrationFee_);
        
        // filter name + condition checks
        bytes32 _name = NameFilter.nameFilter(_nameString);
        
        // set up address 
        address _addr = msg.sender;
        
        // set up our tx event data and determine if player is new or not
        bool _isNewPlayer = determinePID(_addr);
        
        // fetch player id
        uint256 _pID = pIDxAddr_[_addr];
        
        // manage affiliate residuals
        // if no affiliate code was given, no new affiliate code was given, or the 
        // player tried to use their own pID as an affiliate code
        if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
        {
            // update last affiliate 
            plyr_[_pID].laff = _affCode;
        } else if (_affCode == _pID) {
            _affCode = 0;
        }
        
        // register name 
        registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
    }
    
    function registerNameXaddr(string _nameString, address _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        // make sure name fees paid
        require (msg.value >= registrationFee_);
        
        // filter name + condition checks
        bytes32 _name = NameFilter.nameFilter(_nameString);
        
        // set up address 
        address _addr = msg.sender;
        
        // set up our tx event data and determine if player is new or not
        bool _isNewPlayer = determinePID(_addr);
        
        // fetch player id
        uint256 _pID = pIDxAddr_[_addr];
        
        // manage affiliate residuals
        // if no affiliate code was given or player tried to use their own, lolz
        uint256 _affID;
        if (_affCode != address(0) && _affCode != _addr)
        {
            // get affiliate ID from aff Code 
            _affID = pIDxAddr_[_affCode];
            
            // if affID is not the same as previously stored 
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }
        
        // register name 
        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
    }
    
    function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        // make sure name fees paid
        require (msg.value >= registrationFee_);
        
        // filter name + condition checks
        bytes32 _name = NameFilter.nameFilter(_nameString);
        
        // set up address 
        address _addr = msg.sender;
        
        // set up our tx event data and determine if player is new or not
        bool _isNewPlayer = determinePID(_addr);
        
        // fetch player id
        uint256 _pID = pIDxAddr_[_addr];
        
        // manage affiliate residuals
        // if no affiliate code was given or player tried to use their own, lolz
        uint256 _affID;
        if (_affCode != "" && _affCode != _name)
        {
            // get affiliate ID from aff Code 
            _affID = pIDxName_[_affCode];
            
            // if affID is not the same as previously stored 
            if (_affID != plyr_[_pID].laff)
            {
                // update last affiliate
                plyr_[_pID].laff = _affID;
            }
        }
        
        // register name 
        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
    }
    
    /**
     * @dev players, if you registered a profile, before a game was released, or
     * set the all bool to false when you registered, use this function to push
     * your profile to a single game.  also, if you've  updated your name, you
     * can use this to push your name to games of your choosing.
     * -functionhash- 0x81c5b206
     * @param _gameID game id 
     */
    function addMeToGame(uint256 _gameID)
        isHuman()
        public
    {
        require(_gameID <= gID_);
        address _addr = msg.sender;
        uint256 _pID = pIDxAddr_[_addr];
        require(_pID != 0);
        uint256 _totalNames = plyr_[_pID].names;
        
        // add players profile and most recent name
        games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
        
        // add list of all names
        if (_totalNames > 1)
            for (uint256 ii = 1; ii <= _totalNames; ii++)
                games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
    }
    
    
    
    /**
     * @dev players use this to change back to one of your old names.  
     * -functionhash- 0xb9291296
     * @param _nameString the name you want to use 
     */
    function useMyOldName(string _nameString)
        isHuman()
        public 
    {
        // filter name, and get pID
        bytes32 _name = _nameString.nameFilter();
        uint256 _pID = pIDxAddr_[msg.sender];
        
        // make sure they own the name 
        require(plyrNames_[_pID][_name] == true);
        
        // update their current name 
        plyr_[_pID].name = _name;
    }