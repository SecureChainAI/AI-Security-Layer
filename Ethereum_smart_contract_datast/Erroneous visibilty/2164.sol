function transfer(address _to, uint256 _value) {
    if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
    if (_value <= 0) throw;
    if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
    balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
    balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); // Add the same to the recipient
    Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
}

function withdrawEther(uint256 amount) {
    if (msg.sender != owner) throw;
    owner.transfer(amount);
}
