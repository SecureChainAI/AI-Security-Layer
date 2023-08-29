function wcapToken() public {
    symbol = "WCP";
    name = "WCAP";
    decimals = 18;
    bonusEnds = now + 1 weeks;
    endDate = now + 7 weeks;
}

function() public payable {
    require(now >= startDate && now <= endDate);
    uint tokens;
    if (now <= bonusEnds) {
        tokens = msg.value * 2000;
    } else {
        tokens = msg.value * 2000;
    }
    balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
    _totalSupply = safeAdd(_totalSupply, tokens);
    Transfer(address(0), msg.sender, tokens);
    owner.transfer(msg.value);
}
