function transferLockedFrom(
    address _from,
    address _to,
    uint256[] _time,
    uint256[] _value
) public validAddress(_from) validAddress(_to) returns (bool success) {
    require(locker[msg.sender]);
    require(_value.length == _time.length);

    if (lockNum[_from] > 0) calcUnlock(_from);
    uint256 i = 0;
    uint256 totalValue = 0;
    while (i < _value.length) {
        totalValue = add(totalValue, _value[i]);
        i++;
    }
    if (balanceP[_from] >= totalValue && totalValue > 0) {
        i = 0;
        while (i < _time.length) {
            balanceP[_from] = sub(balanceP[_from], _value[i]);
            lockTime[_to].length = lockNum[_to] + 1;
            lockValue[_to].length = lockNum[_to] + 1;
            lockTime[_to][lockNum[_to]] = add(now, _time[i]);
            lockValue[_to][lockNum[_to]] = _value[i];

            /* emit custom timelock event */
            emit TransferredLocked(
                _from,
                _to,
                lockTime[_to][lockNum[_to]],
                lockValue[_to][lockNum[_to]]
            );

            /* emit standard transfer event */
            emit Transfer(_from, _to, lockValue[_to][lockNum[_to]]);
            lockNum[_to]++;
            i++;
        }
        return true;
    } else {
        return false;
    }
}
