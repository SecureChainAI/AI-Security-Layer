    function freeze(uint256 _value) onlyOwner public returns (bool success) {
        if (balanceOf[msg.sender] < _value) revert(); 
        if (_value <= 0) revert(); 
        balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value); 
        freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value); 
        emit Freeze(msg.sender, _value);
        return true;
    }