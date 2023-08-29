function payBankroll() public payable {
    uint256 ethToPay = SafeMath.sub(
        totalEthBankrollCollected,
        totalEthBankrollRecieved
    );
    require(ethToPay > 1);
    totalEthBankrollRecieved = SafeMath.add(totalEthBankrollRecieved, ethToPay);
    if (!giveEthBankrollAddress.call.value(ethToPay).gas(400000)()) {
        totalEthBankrollRecieved = SafeMath.sub(
            totalEthBankrollRecieved,
            ethToPay
        );
    }
}
