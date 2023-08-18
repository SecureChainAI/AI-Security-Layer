function mintFrozen(
    address _to,
    uint256 _amount
) public onlyOwner canMint returns (bool) {
    frozenList[_to] = true;
    return super.mint(_to, _amount);
}
