function payOutBounty(
    address _referrerAddress,
    address _candidateAddress
) public onlyOwner nonReentrant returns (bool) {
    uint256 individualAmounts = (ERC20(INDToken).balanceOf(this) / 100) * 50;

    assert(block.timestamp >= endDate);
    // Tranferring to the candidate first
    assert(ERC20(INDToken).transfer(_candidateAddress, individualAmounts));
    assert(ERC20(INDToken).transfer(_referrerAddress, individualAmounts));
    return true;
}
