function _transfer(address _from, address _to, uint _value) internal {
    require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
    require(balanceOf[_from] >= _value); // Check if the sender has enough
    require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
    uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
    balanceOf[_from] -= _value; // Subtract from the sender
    balanceOf[_to] += _value; // Add the same to the recipient
    emit Transfer(_from, _to, _value);
    assert(balanceOf[_from] + balanceOf[_to] == previousBalances); // Asserts are used to use static analysis to find bugs in your code. They should never fail
}

function transfer(address _to, uint256 _value) public {
    _transfer(msg.sender, _to, _value);
}
