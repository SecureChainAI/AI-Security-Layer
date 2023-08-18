function transferToContract(
    address _to,
    uint256 _value,
    bytes _data
) internal returns (bool) {
    require(balances[msg.sender] >= _value);
    require(vestingEnded(msg.sender));

    // This will override settings and allow contract owner to send to contract
    if (msg.sender != contractOwner) {
        ERC223ReceivingContract _tokenReceiver = ERC223ReceivingContract(_to);
        _tokenReceiver.tokenFallback(msg.sender, _value, _data);
    }

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);
    emit Transfer(msg.sender, _to, _value, _data);
    return true;
}
