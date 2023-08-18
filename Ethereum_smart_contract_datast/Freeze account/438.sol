function freeze(address target,uint256 _value) onlyOwner public returns (bool success) {
        if (balanceOf[target] < _value) revert();            // Check if the sender has enough
		if (_value <= 0) revert(); 
        balanceOf[target] = balanceOf[target].sub(_value);                      // Subtract from the sender
        freezeOf[target] = freezeOf[target].add(_value);                                // Updates totalSupply
        emit Freeze(target, _value);
        return true;
    }