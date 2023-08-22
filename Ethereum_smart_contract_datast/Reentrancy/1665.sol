function claimRefund() public onlyTokenHolders {
    // Check the state.
    require(state == State.Refunding);

    // Validate the time.
    require(now > refundLockDate + REFUND_LOCK_DURATION);

    // Calculate the transfering wei and burn all the token of the refunder.
    uint256 amount = address(this).balance.mul(token.balanceOf(msg.sender)).div(
        token.totalSupply()
    );
    token.burnAll(msg.sender);

    // Signal the event.
    msg.sender.transfer(amount);
}
