function revoke() public onlyOwner {
    require(revocable);
    require(!revoked[token]);

    uint256 balance = token.balanceOf(this);

    uint256 unreleased = releasableAmount();
    uint256 refund = balance.sub(unreleased);

    revoked[token] = true;

    token.safeTransfer(rollback, refund);

    emit Revoked();
}
