function confirmERC20(bytes32 _h) public onlymanyowners(_h) returns (bool) {
    if (m_txs[_h].to != 0) {
        ERC20Basic token = ERC20Basic(m_txs[_h].token);
        token.transfer(m_txs[_h].to, m_txs[_h].value);
        emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
        delete m_txs[_h];
        return true;
    }
}
