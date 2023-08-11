  function batchFreeze(address[] _addresses, bool _freeze) onlyOwner public {
        for (uint i = 0; i < _addresses.length; i++) {
            frozenAccount[_addresses[i]] = _freeze;
            emit FrozenFunds(_addresses[i], _freeze);
        }
    }