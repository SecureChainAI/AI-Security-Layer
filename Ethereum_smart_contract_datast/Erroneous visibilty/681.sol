function() payable {
    if (!isFunding) throw;
    if (msg.value == 0) throw;

    if (block.number < fundingStartBlock) throw;
    if (block.number > fundingStopBlock) throw;

    uint256 tokens = safeMult(msg.value, tokenExchangeRate);
    if (tokens + tokenRaised > currentSupply) throw;

    tokenRaised = safeAdd(tokenRaised, tokens);
    balances[msg.sender] += tokens;

    IssueToken(msg.sender, tokens); //记录日志
}

function ULChain(address _ethFundDeposit, uint256 _currentSupply) {
    ethFundDeposit = _ethFundDeposit;

    isFunding = false; //通过控制预CrowdS ale状态
    fundingStartBlock = 0;
    fundingStopBlock = 0;

    currentSupply = formatDecimals(_currentSupply);
    totalSupply = formatDecimals(1000000000);
    balances[msg.sender] = totalSupply;
    if (currentSupply > totalSupply) throw;
}

function allowance(
    address _owner,
    address _spender
) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
}

function approve(address _spender, uint256 _value) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}
