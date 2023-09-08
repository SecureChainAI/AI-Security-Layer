function tokenFallback(address _from, uint256 _value, bytes) public {
    require(msg.sender == address(token));
    for (uint256 i = 0; i < phases.length; i++) {
        // solium-disable-next-line security/no-block-members
        if (phases[i].startDate <= now && now <= phases[i].endDate) {
            require(token.burn(_value));
            emit Burn(_from, _value, phases[i].discount);
            return;
        }
    }
    revert();
}
