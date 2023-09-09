function freezeTokens(
    address _beneficiary,
    uint256 _amount,
    uint256 _when
) public {
    require(rightAndRoles.onlyRoles(msg.sender, 1));
    freeze storage _freeze = freezedTokens[_beneficiary];
    _freeze.amount = _amount;
    _freeze.when = _when;
}
