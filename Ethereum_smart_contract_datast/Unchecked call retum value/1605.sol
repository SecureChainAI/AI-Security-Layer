function withdrawTokens(
    ERC20 erc20,
    address reciver,
    uint amount
) public onlyOwner {
    require(reciver != address(0x0));
    erc20.transfer(reciver, amount);
}
