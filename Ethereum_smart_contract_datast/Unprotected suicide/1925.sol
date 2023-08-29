function destroy() external onlyOwner {
    require(token.balanceOf(this) == 0);
    selfdestruct(owner);
}
