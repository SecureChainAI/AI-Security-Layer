function transferableBalanceOf(
    address _of
) public view returns (uint256 amount) {
    uint256 lockedAmount = 0;
    lockedAmount += tokensLocked(_of, block.timestamp);
    amount = balances[_of].sub(lockedAmount);
}
