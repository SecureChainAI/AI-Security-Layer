uint public startDate;
    function () public payable {
        require(now >= startDate && now <= endDate);
        uint tokens;
        if (now <= bonusEnds) {
            tokens = msg.value * 500000001;
        } else {
            tokens = msg.value * 14000000000000000000000;
        }
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
        _totalSupply = safeAdd(_totalSupply, tokens);
        Transfer(address(0), msg.sender, tokens);
        owner.transfer(msg.value);
    }