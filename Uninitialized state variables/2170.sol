function tokenFallback(address _from, uint _value, bytes _data) public pure {
    TKN memory tkn;
    tkn.sender = _from;
    tkn.value = _value;
    tkn.data = _data;
    uint32 u = uint32(_data[3]) +
        (uint32(_data[2]) << 8) +
        (uint32(_data[1]) << 16) +
        (uint32(_data[0]) << 24);
    tkn.sig = bytes4(u);
}
