function release() public onlyOwner {
    require(isLocked);
    require(!isReleased);
    require(lockOver());
    uint256 token_amount = tokenBalance();
    token_reward.transfer(beneficiary, token_amount);
    emit TokenReleased(beneficiary, token_amount);
    isReleased = true;
}
