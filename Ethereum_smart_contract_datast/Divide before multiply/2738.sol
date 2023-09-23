function buyKey() public payable newRoundIfNeeded returns (uint) {
    require(msg.value > 0);
    uint _msgValue = msg.value;
    uint _amountToShares = _msgValue.div(100).mul(configPerShares);
    uint _amountToFund = _msgValue.div(100).mul(configPerFund);
    uint _amountToPot = _msgValue.sub(_amountToShares).sub(_amountToFund);
    uint _keys = _msgValue.div(roundPrice);
    require(configMaxKeys >= _keys);
    ownerEth = ownerEth.add(_amountToFund);
    fundoShares(_amountToShares);
    roundEth = roundEth.add(_msgValue);
    roundEthShares = roundEthShares.add(_amountToShares);
    roundKeys = roundKeys.add(_keys);
    roundPot = roundPot.add(_amountToPot);
    allEth = allEth.add(_msgValue);
    allEthShares = allEthShares.add(_amountToShares);
    allKeys = allKeys.add(_keys);
    funComputeRoundPrice();
    funComputeRoundTime(_keys);
    roundLeader = msg.sender;

    if (accountKeys[msg.sender] <= 0 || accountRounds[msg.sender] != round)
        roundAddress.push(msg.sender);
    if (accountRounds[msg.sender] == round) {
        accountKeys[msg.sender] = accountKeys[msg.sender].add(_keys);
    } else {
        accountRounds[msg.sender] = round;
        accountKeys[msg.sender] = _keys;
    }

    return _keys;
}
