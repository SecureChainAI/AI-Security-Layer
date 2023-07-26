function updateSupply() internal returns (uint256) {
    if (now - timeOfLastHalving >= 2100000 minutes) {
        reward /= 2;
        timeOfLastHalving = now;
    }

    if (now - timeOfLastIncrease >= 150 seconds) {
        uint256 increaseAmount = ((now - timeOfLastIncrease) / 150 seconds) *
            reward;//Divide before multiply
        spendable_supply += increaseAmount;
        unspent_supply += increaseAmount;
        timeOfLastIncrease = now;
    }

    circulating_supply = spendable_supply - unspent_supply;

    return circulating_supply;
}
