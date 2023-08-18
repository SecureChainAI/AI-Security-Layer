function payJackpot() public payable {
    uint256 ethToPay = SafeMath.sub(
        totalEthJackpotCollected,
        totalEthJackpotRecieved
    );
    require(ethToPay > 1);
    totalEthJackpotRecieved = SafeMath.add(totalEthJackpotRecieved, ethToPay);
    if (!giveEthJackpotAddress.call.value(ethToPay).gas(400000)()) {
        totalEthJackpotRecieved = SafeMath.sub(
            totalEthJackpotRecieved,
            ethToPay
        );
    }
}
