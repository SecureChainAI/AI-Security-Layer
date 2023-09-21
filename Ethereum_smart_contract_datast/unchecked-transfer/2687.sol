    token.transfer(_beneficiary, _tokenAmount);
    token.transfer(wallet, balanceOfThis);
        token.transferFrom(wallet, contributors[i], bonusTokens[contributors[i]]);
        token.transferFrom(wallet, _bonusList[i], bonusTokens[_bonusList[i]]);
