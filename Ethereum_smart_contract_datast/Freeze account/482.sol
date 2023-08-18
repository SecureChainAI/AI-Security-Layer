	function freeze(uint256 _value) returns (bool success) {
        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
		if (_value <= 0) throw; 
        balanceOf[msg.sender] = KVCMath.kvcSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
        freezeOf[msg.sender] = KVCMath.kvcAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
        Freeze(msg.sender, _value);
        return true;
    }