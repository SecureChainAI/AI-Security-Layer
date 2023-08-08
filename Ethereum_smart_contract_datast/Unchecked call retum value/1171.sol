function exerciseOption(uint _pustBalance) public returns (bool) {
    require(now < ExerciseEndTime);
    require(_pustBalance <= balances[msg.sender]);

    uint _ether = _pustBalance * 10 ** 18;
    require(address(this).balance >= _ether);

    uint _amount = _pustBalance * exchangeRate * 10 ** 18;
    require(
        PUST(ustAddress).transferFrom(msg.sender, officialAddress, _amount) ==
            true
    );

    balances[msg.sender] = safeSub(balances[msg.sender], _pustBalance);
    totalSupply = safeSub(totalSupply, _pustBalance);
    msg.sender.transfer(_ether); // convert units from ether to wei
    emit exchange(address(this), msg.sender, _pustBalance);
}
