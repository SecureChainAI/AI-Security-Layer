pragma solidity ^0.4.24;

function withdrawAltcoinTokens(
    address _tokenContract
) public onlyOwner returns (bool) {
    AltcoinToken token = AltcoinToken(_tokenContract);
    uint256 amount = token.balanceOf(address(this));
    return token.transfer(owner, amount);
}
