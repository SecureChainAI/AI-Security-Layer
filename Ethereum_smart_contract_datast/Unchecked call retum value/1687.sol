function claimTokensToOwner(address _token) public onlyOwner {
    if (_token == 0x0) {
        owner.transfer(address(this).balance);
        return;
    }
    TaurusPay token = TaurusPay(_token);
    uint256 balance = token.balanceOf(this);
    token.transfer(owner, balance);
    emit Transfer(_token, owner, balance);
}
