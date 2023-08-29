function emergencyERC20Drain(ERC20 _token) external onlyOwner {
    // owner can drain tokens that are sent here by mistake
    uint256 drainAmount;
    if (address(_token) == address(token)) {
        drainAmount = _token.balanceOf(this).sub(totalDepositBalance);
    } else {
        drainAmount = _token.balanceOf(this);
    }
    _token.transfer(owner, drainAmount);
}
