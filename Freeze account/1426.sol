function systemFreeze(uint256 _value, uint256 _unfreezeTime) internal {
    uint256 unfreezeIndex = uint256(_unfreezeTime.parseTimestamp().year) *
        10000 +
        uint256(_unfreezeTime.parseTimestamp().month) *
        100 +
        uint256(_unfreezeTime.parseTimestamp().day);
    balances[owner] = balances[owner].sub(_value);
    frozenRecords[unfreezeIndex] = FrozenRecord({
        value: _value,
        unfreezeIndex: unfreezeIndex
    });
    frozenBalance = frozenBalance.add(_value);
    emit SystemFreeze(owner, _value, _unfreezeTime);
}
