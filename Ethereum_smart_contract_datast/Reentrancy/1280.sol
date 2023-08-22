function transferToContract(
    address _to,
    uint _value,
    bytes _data
) private returns (bool) {
    require(block.timestamp > frozenTimestamp[msg.sender]);
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    ReceivingContract receiver = ReceivingContract(_to);
    receiver.tokenFallback(msg.sender, _value, _data);
    emit Transfer(msg.sender, _to, _value, _data);
    return true;
}
