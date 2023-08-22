function approveMint(
    uint256 nonce
)
    external
    onlyValidator
    checkIsInvestorApproved(pendingMints[nonce].to)
    returns (bool)
{
    // update state
    weiRaised = weiRaised.add(pendingMints[nonce].weiAmount);
    totalSupply = totalSupply.add(pendingMints[nonce].tokens);

    //No need to use mint-approval on token side, since the minting is already approved in the crowdsale side
    token.mint(pendingMints[nonce].to, pendingMints[nonce].tokens);

    emit TokenPurchase(
        msg.sender,
        pendingMints[nonce].to,
        pendingMints[nonce].weiAmount,
        pendingMints[nonce].tokens
    );

    forwardFunds(pendingMints[nonce].weiAmount);
    delete pendingMints[nonce];

    return true;
}
