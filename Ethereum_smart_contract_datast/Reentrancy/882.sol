function transfer(address _to, uint _value, bytes _data) public verifyTheLock {
    // Standard function transfer similar to ERC20 transfer with no _data .
    // Added due to backwards compatibility reasons .
    uint codeLength;

    assembly {
        // Retrieve the size of the code on target address, this needs assembly .
        codeLength := extcodesize(_to)
    }

    if (balanceOf(msg.sender) < _value) revert();
    require(_verifyOptionPoolIncome(_to, _value));
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    _verifyOptionPoolDefray(_to);
    if (codeLength > 0) {
        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
    }
    emit Transfer(msg.sender, _to, _value, _data);
}
