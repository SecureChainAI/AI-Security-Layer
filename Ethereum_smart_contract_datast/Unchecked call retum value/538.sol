function claimTokens(address _token) public onlyOwner {
    if (_token == 0x0) {
        owner.transfer(address(this).balance);
        return;
    }

    ERC20 token = ERC20(_token);
    uint balance = token.balanceOf(this);
    token.transfer(owner, balance);

    emit ClaimedTokens(_token, owner, balance);
}
