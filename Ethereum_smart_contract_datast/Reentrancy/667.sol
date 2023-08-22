function releaseToken() public onlyReserveWallets {
    uint256 totalUnlocked = unlockAmount();
    require(totalUnlocked <= allocations[msg.sender]);
    require(releasedAmounts[msg.sender] < totalUnlocked);
    uint256 payment = totalUnlocked.sub(releasedAmounts[msg.sender]);

    releasedAmounts[msg.sender] = totalUnlocked;
    require(token.transfer(msg.sender, payment));
}
