   function freeze(uint256 _value) public returns (bool success) {
        require(_value > 0);
        require(balanceOf[msg.sender] >= _value);                                   // Check if the sender has enough
        require(freezeOf[msg.sender] + _value >= freezeOf[msg.sender]);             // Check for Overflows
        require(freezeOf[msg.sender] + _value >= _value);                           // Check for Overflows
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);    // Subtract from the sender
        freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);      // Updates totalSupply
        emit Freeze(msg.sender, _value);
        return true;
    }