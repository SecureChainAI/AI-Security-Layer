   function freezeAccount(address target, bool value) onlyOwner public {
        frozenAccount[target] = value;
        emit FrozenFunds(target, value);
    }
