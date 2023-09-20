function UnityToken(address _ethFundDeposit, uint256 _currentSupply) {
    ethFundDeposit = _ethFundDeposit;

    isFunding = false; //通过控制预CrowdS ale状态
    fundingStartBlock = 0;
    fundingStopBlock = 0;

    currentSupply = formatDecimals(_currentSupply);
    totalSupply = formatDecimals(10000000);
    balances[msg.sender] = totalSupply;
    if (currentSupply > totalSupply) throw;
}
