function freeze(address _to, uint256 _value) onlyOwner returns (bool success) {
    require(_value >= 0);
    require(balances[_to] >= _value);
    balances[_to] = balances[_to].sub(_value); // Subtract from the sender
    freezeOf[_to] = freezeOf[_to].add(_value); // Updates totalSupply
    Freeze(_to, _value);
    return true;
}
