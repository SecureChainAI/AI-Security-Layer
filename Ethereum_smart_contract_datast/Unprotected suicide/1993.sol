function destroy(address[] tokens) public onlyOwner {
    // Transfer tokens to owner
    for (uint256 i = 0; i < tokens.length; i++) {
        ERC20Basic token = ERC20Basic(tokens[i]);
        uint256 balance = token.balanceOf(this);
        token.transfer(owner, balance);
    }
    selfdestruct(owner);
}
