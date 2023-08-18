function transferToContract(
    address _to,
    uint _value,
    bytes _data
) private returns (bool success) {
    if (balanceOf(msg.sender) < _value) revert();
    _balances[msg.sender] = balanceOf(msg.sender).sub(_value);
    _balances[_to] = balanceOf(_to).add(_value);
    ContractReceiver receiver = ContractReceiver(_to);
    receiver.tokenFallback(msg.sender, _value, _data);
    emit Transfer(msg.sender, _to, _value);
    return true;
}
