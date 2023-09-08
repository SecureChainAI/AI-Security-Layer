   function freezeAccount(address target,bool freeze)  onlyOwner public{
        require(target!=owner);
        frozenAccount[target] = freeze;
        emit FrozenFunds(target,freeze);
    }