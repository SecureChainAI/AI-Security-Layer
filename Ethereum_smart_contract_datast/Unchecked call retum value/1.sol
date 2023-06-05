pragma solidity ^0.4.8;

function transfer(address _to, uint256 _value) {
    if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
    if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
    if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
    balanceOf[msg.sender] -= _value; // Subtract from the sender
    balanceOf[_to] += _value; // Add the same to the recipient
    Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
}

function approve(address _spender, uint256 _value) returns (bool success) {
    allowance[msg.sender][_spender] = _value;
    return true;
}

function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _extraData
) returns (bool success) {
    tokenRecipient spender = tokenRecipient(_spender);
    if (approve(_spender, _value)) {
        spender.receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }
}
