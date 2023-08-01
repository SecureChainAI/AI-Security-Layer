function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.transfer(_beneficiary, _tokenAmount);
}

function withdrawTokens() public onlyOwner {
    uint256 unsold = token.balanceOf(this);
    token.transfer(owner, unsold);
}
