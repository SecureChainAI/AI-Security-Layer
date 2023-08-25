function transferToken(
    address token,
    address toAddress,
    uint256 amount
) public {
    require(AddressManager(_addressManagerAddress).isTank(msg.sender));
    ERC20(token).transfer(toAddress, amount);
}
