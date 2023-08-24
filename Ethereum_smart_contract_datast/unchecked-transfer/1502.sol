        bctToken.transfer(_client, amount * ethUsdRate / bctToken.price());
        bctToken.transfer(_addr, _amount);
