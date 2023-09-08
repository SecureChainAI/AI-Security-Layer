function WrapperLock(
    address _originalToken,
    string _name,
    string _symbol,
    uint _decimals,
    address _transferProxy,
    bool _erc20old
) Ownable {
    originalToken = _originalToken;
    TRANSFER_PROXY = _transferProxy;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    isSigner[msg.sender] = true;
    erc20old = _erc20old;
}
