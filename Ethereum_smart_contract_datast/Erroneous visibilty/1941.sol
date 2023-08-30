function createTokens(uint256 _value) returns (bool success) {
    require(msg.sender == owner);

    if (_value > 0) {
        if (_value > safeSub(MAX_TOKEN_COUNT, tokenCount)) return false;

        accounts[msg.sender] = safeAdd(accounts[msg.sender], _value);
        tokenCount = safeAdd(tokenCount, _value);

        // adding transfer event and _from address as null address
        emit Transfer(0x0, msg.sender, _value);

        return true;
    }

    return false;
}
