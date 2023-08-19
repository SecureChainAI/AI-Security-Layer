function withdraw() public {
    require(userPackages[msg.sender].tokenValue != 0);
    uint256 withdrawValue = userPackages[msg.sender].tokenValue.div(rate);
    uint256 dateDiff = now - userPackages[msg.sender].since;
    if (dateDiff < userPackages[msg.sender].kindOf.mul(30 days)) {
        uint256 fee = withdrawValue
            .mul(packageType[userPackages[msg.sender].kindOf]["fee"])
            .div(100);
        withdrawValue = withdrawValue.sub(fee);
        coldWalletAddress.transfer(fee);
    }
    userPackages[msg.sender].tokenValue = 0;
    msg.sender.transfer(withdrawValue);
}
