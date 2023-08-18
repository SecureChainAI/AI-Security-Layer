 function freezeAccount(address _holder) public onlyOwner returns (bool) {
        require(!frozen[_holder]);
        frozen[_holder] = true;
        emit Freeze(_holder);
        return true;
    }