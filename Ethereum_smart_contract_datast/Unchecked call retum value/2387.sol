function transferToken(
    ERC20 erc20,
    address to,
    uint256 value
) public onlyFsTKAuthorized {
    erc20.transfer(to, value);
}
