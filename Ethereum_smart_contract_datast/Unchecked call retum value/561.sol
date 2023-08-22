function claimTokens(address _token) public onlyOwner {
    if (_token == address(0)) {
        owner.transfer(address(this).balance);
        return;
    }

    ERC20 token = ERC20(_token);
    uint balance = token.balanceOf(address(this));
    token.transfer(owner, balance);
    emit ClaimedTokens(_token, owner, balance);
}
