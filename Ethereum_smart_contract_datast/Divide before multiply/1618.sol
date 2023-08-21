function _transfer(address _from, address _to, uint256 _value) internal {
    require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
    require(balanceOf[_from] >= _value); // Check if the sender has enough
    require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
    require(!frozenAccount[_from]); // Check if sender is frozen
    require(!frozenAccount[_to]); // Check if recipient is frozen

    // LOCK COINS
    uint start = 1532964203;

    //address peAccount = 0xf28a2a16546110138F255cc3c2D76460B8517297;
    address fundAccount = 0xa61FDFb4b147Eb2b02790B779E6DfBe308394C98;
    //address bizAccount = 0xaeF0f5D901cb6b8FEF95C019612C80f040F76b24;
    address teamAccount = 0xF9367C4bE8e47f46827AdB2cFEBFd6b265C3C3B0;
    //address partnerAccount = 0x40fbcb153caC1299BDe8f880FE668e0DC07b1Fea;

    uint256 amount = _value;
    address sender = _from;
    uint256 balance = balanceOf[_from];

    if (fundAccount == sender) {
        if (now < start + 365 * 1 days) {
            require((balance - amount) >= (((totalSupply * 3) / 20) * 3) / 4);
        } else if (now < start + (2 * 365 + 1) * 1 days) {
            require((balance - amount) >= (((totalSupply * 3) / 20) * 2) / 4);
        } else if (now < start + (3 * 365 + 1) * 1 days) {
            require((balance - amount) >= (((totalSupply * 3) / 20) * 1) / 4);
        } else {
            require((balance - amount) >= 0);
        }
    } else if (teamAccount == sender) {
        if (now < start + 365 * 1 days) {
            require((balance - amount) >= ((totalSupply / 10) * 3) / 4);
        } else if (now < start + (2 * 365 + 1) * 1 days) {
            require((balance - amount) >= ((totalSupply / 10) * 2) / 4);
        } else if (now < start + (3 * 365 + 1) * 1 days) {
            require((balance - amount) >= ((totalSupply / 10) * 1) / 4);
        } else {
            require((balance - amount) >= 0);
        }
    }

    balanceOf[_from] -= _value; // Subtract from the sender
    balanceOf[_to] += _value; // Add the same to the recipient
    emit Transfer(_from, _to, _value);
}
