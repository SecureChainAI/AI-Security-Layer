function freezeTokens(
    uint256 _amount,
    uint _unfreezeDate
) public isFreezeAllowed returns (bool) {
    //We can freeze tokens only if there are no frozen tokens on the wallet.
    require(
        wallets[msg.sender].freezedAmount == 0 &&
            wallets[msg.sender].tokensAmount >= _amount
    );
    wallets[msg.sender].freezedAmount = _amount;
    wallets[msg.sender].unfreezeDate = _unfreezeDate;
    emit FreezeTokens(msg.sender, _amount);
    return true;
}
