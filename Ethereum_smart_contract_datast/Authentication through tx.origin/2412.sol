modifier isHuman() {
        address _addr = msg.sender;
        uint256 _codeLength;
        require (msg.sender == tx.origin);
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0);
        
        _;
    }