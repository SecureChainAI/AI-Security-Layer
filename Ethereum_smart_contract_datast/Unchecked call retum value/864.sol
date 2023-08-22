function withdrawTokens(address tokenContract) external {
    require(msg.sender == owner);
    WithdrawableToken tc = WithdrawableToken(tokenContract);

    tc.transfer(owner, tc.balanceOf(this));
}
