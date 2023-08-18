function distr(address _to, uint256 _amount) private canDistr returns (bool) {
    totalDistributed = totalDistributed.add(_amount);
    totalRemaining = totalRemaining.sub(_amount);
    balances[_to] = balances[_to].add(_amount);
    Distr(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;

    if (totalDistributed >= totalSupply) {
        distributionFinished = true;
    }
}
