function _transfer(address _from, address _to, uint _value) internal {
    require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
    require(balanceOf[_from] >= _value); // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
    require(!frozenAccount[_from]); // Check if sender is frozen
    require(!frozenAccount[_to]); // Check if recipient is frozen

    // LOCK COINS
    uint start = 1532944800;
    uint256 DSTtotalAmount = totalSupply;
    address teamaccount = 0xFF7B4596cEF5dC7D15fBcFA9AA0C1516125399af;

    uint256 amount = _value;
    address sender = _from;
    uint256 balance = balanceOf[_from];

    if (teamaccount == sender) {
        if (now < start + 365 * 1 days) {
            require((balance - amount) >= ((DSTtotalAmount / 10) * 3) / 4);
        } else if (now < start + (2 * 365 + 1) * 1 days) {
            require((balance - amount) >= ((DSTtotalAmount / 10) * 2) / 4);
        } else if (now < start + (3 * 365 + 1) * 1 days) {
            require((balance - amount) >= ((DSTtotalAmount / 10) * 1) / 4);
        }
    }

    balanceOf[_from] -= _value; // Subtract from the sender
    balanceOf[_to] += _value; // Add the same to the recipient
    emit Transfer(_from, _to, _value);
}
