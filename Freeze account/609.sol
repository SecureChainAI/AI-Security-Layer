function freezeAccount(
    address _userAddress,
    uint256 _amount
) public onlyOwner returns (bool success) {
    require(balance(_userAddress) >= _amount);
    userLockedTokens[_userAddress] = userLockedTokens[_userAddress].add(
        _amount
    );
    emit Freeze(_userAddress, _amount);
    return true;
}
