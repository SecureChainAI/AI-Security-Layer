        require(registeredSymbols[symbol].status != true, "Symbol status should not equal to true");
 require(registeredSymbols[symbol].owner == _owner, "Owner of the symbol should matched with the requested issuer address");
        require(registeredSymbols[symbol].timestamp.add(expiryLimit) >= now, "Ticker should not be expired");
        else if (registeredSymbols[symbol].owner == address(0) || expiryCheck(symbol)) {
        if (registeredSymbols[symbol].status == true||registeredSymbols[symbol].timestamp.add(expiryLimit) > now) {
      if (registeredSymbols[_symbol].owner != address(0)) {
            if (now > registeredSymbols[_symbol].timestamp.add(expiryLimit) && registeredSymbols[_symbol].status != true) {
