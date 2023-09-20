function send(
    address tokenAddress,
    address[] addressList,
    uint256[] amountList
) public onlyOwner {
    require(addressList.length == amountList.length);
    for (uint i = 0; i < addressList.length; i++) {
        ERC20(tokenAddress).transfer(addressList[i], amountList[i] * 1e18);
    }
}
