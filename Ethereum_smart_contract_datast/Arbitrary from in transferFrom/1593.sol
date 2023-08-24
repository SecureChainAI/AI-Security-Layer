    require(token.transferFrom(from, to, value));
    token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
