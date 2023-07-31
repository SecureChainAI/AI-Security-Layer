function multisendToken(
    address token,
    address[] _contributors,
    uint256[] _balances
) public payable hasFee {
    if (token == 0x000000000000000000000000000000000000bEEF) {
        multisendEther(_contributors, _balances);
    } else {
        uint256 total = 0;
        require(_contributors.length <= arrayLimit());
        ERC20 erc20token = ERC20(token);
        uint8 i = 0;
        for (i; i < _contributors.length; i++) {
            erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
            total += _balances[i];
        }
        setTxCount(msg.sender, txCount(msg.sender).add(1));
        emit Multisended(total, token);
    }
}
