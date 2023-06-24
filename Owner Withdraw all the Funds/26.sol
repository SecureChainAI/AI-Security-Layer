pragma solidity ^0.4.18;

function withdraw() public onlyOwner {
    address myAddress = this;
    uint256 etherBalance = myAddress.balance;
    owner.transfer(etherBalance);
}

function withdrawForeignTokens(
    address _tokenContract
) public onlyOwner returns (bool) {
    ForeignToken token = ForeignToken(_tokenContract);
    uint256 amount = token.balanceOf(address(this));
    return token.transfer(owner, amount);
}
