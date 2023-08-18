function balanceLocked(
    address _address
) public view returns (uint256 _balance) {
    _balance = 0;
    uint256 i = 0;
    while (i < lockNum[_address]) {
        if (add(now, earlier) < add(lockTime[_address][i], later))
            _balance = add(_balance, lockValue[_address][i]);
        i++;
    }
    return _balance;
}
