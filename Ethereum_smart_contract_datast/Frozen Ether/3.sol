pragma solidity ^0.4.18;

function freezeAccounts(address[] targets, bool isFrozen) public onlyOwner {
    require(targets.length > 0);

    for (uint i = 0; i < targets.length; i++) {
        require(targets[i] != 0x0);
        frozenAccount[targets[i]] = isFrozen;
        FrozenFunds(targets[i], isFrozen);
    }
}

function transfer(
    address _to,
    uint _value,
    bytes _data
) public returns (bool success) {
    require(
        _value > 0 &&
            frozenAccount[msg.sender] == false &&
            frozenAccount[_to] == false &&
            now > unlockUnixTime[msg.sender] &&
            now > unlockUnixTime[_to]
    );

    if (isContract(_to)) {
        return transferToContract(_to, _value, _data);
    } else {
        return transferToAddress(_to, _value, _data);
    }
}
