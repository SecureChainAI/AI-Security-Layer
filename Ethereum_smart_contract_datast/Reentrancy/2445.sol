   function() public payable {
        _updatePhase(true);
        address sender = msg.sender;
        uint256 amountEth = msg.value;
        uint256 remainedCoin = token.balanceOf(base_wallet);
        if (remainedCoin == 0) {
            sender.transfer(amountEth);
            _finalizeICO();
        } else {
            uint8 percent = bonus_percents[uint256(phase_i)];
            uint256 amountCoin = calcTokensFromEth(amountEth);
            assert(amountCoin >= MIN_TOKEN_AMOUNT);
            if (amountCoin > remainedCoin) {
                lastPayerOverflow = amountCoin.sub(remainedCoin);
                amountCoin = remainedCoin;
            }
            base_wallet.transfer(amountEth);
            token.transferICO(sender, amountCoin);
            _addPayment(sender, amountEth, amountCoin, percent);
            if (amountCoin == remainedCoin)
                _finalizeICO();
        }
    }
