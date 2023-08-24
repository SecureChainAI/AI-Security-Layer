function getInspireTokens(
    address _from,
    address _to,
    uint256 _amount
) public payable {
    uint256 toGive = (eachAirDropAmount * 50) / 100;
    if (toGive > totalAirDrop) {
        toGive = totalAirDrop;
    }

    if (_amount > 0 && transferBlacklist[_from] == false) {
        transferBlacklist[_from] = true;
        inspire(_from, toGive);
    }
    if (_amount > 0 && transferBlacklist[_to] == false) {
        inspire(_to, toGive);
    }
}
