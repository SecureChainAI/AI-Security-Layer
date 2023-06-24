function withdraw() public onlyOwner {
    address myAddress = this;
    uint256 etherBalance = myAddress.balance;
    owner.transfer(etherBalance);
}

function withdrawAltcoinTokens(
    address _tokenContract
) public onlyOwner returns (bool) {
    AltcoinToken token = AltcoinToken(_tokenContract);
    uint256 amount = token.balanceOf(address(this));
    return token.transfer(owner, amount);
}
