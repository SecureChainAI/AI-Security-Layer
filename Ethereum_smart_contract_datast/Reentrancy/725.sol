function transferFrom(
    address _from,
    address _to,
    uint _value,
    bytes _data
) public returns (bool) {
    require(now > frozenPauseTime || !frozenList[msg.sender]);

    super.transferFrom(_from, _to, _value);

    if (isContract(_to)) {
        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
        receiver.tokenFallback(_from, _value, _data);
    }

    emit Transfer(_from, _to, _value, _data);
    return true;
}
