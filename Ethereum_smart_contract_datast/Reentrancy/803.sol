function cardPresale(uint16 _protoId) external payable whenNotPaused {
    uint16 curSupply = cardPresaleCounter[_protoId];
    require(curSupply > 0);
    require(msg.value == 0.25 ether);
    uint16[] storage buyArray = OwnerToPresale[msg.sender];
    uint16[5] memory param = [10000 + _protoId, _protoId, 6, 0, 1];
    tokenContract.createCard(msg.sender, param, 1);
    buyArray.push(_protoId);
    cardPresaleCounter[_protoId] = curSupply - 1;
    emit CardPreSelled(msg.sender, _protoId);

    jackpotBalance += (msg.value * 2) / 10;
    addrFinance.transfer(address(this).balance - jackpotBalance);
    //1%
    uint256 seed = _rand();
    if (seed % 100 == 99) {
        emit Jackpot(msg.sender, jackpotBalance, 2);
        msg.sender.transfer(jackpotBalance);
    }
}
