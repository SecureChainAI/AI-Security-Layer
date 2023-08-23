function transfer(
    address _to,
    uint256 _value,
    bytes _data,
    string _fallback
) public whenNotPaused returns (bool) {
    require(_to != address(0));

    if (isContract(_to)) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        assert(
            _to.call.value(0)(
                bytes4(keccak256(abi.encodePacked(_fallback))),
                msg.sender,
                _value,
                _data
            )
        );

        if (_data.length == 0) {
            emit Transfer(msg.sender, _to, _value);
        } else {
            emit Transfer(msg.sender, _to, _value);
            emit Transfer(msg.sender, _to, _value, _data);
        }
        return true;
    } else {
        return transferToAddress(msg.sender, _to, _value, _data);
    }
}
