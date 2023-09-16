function freeze(
    address _investor,
    uint256 _value
) public onlyFreezeAdmin returns (bool) {
    require(_investor != 0x0 && !AddressUtils.isContract(_investor));

    require(_value > 0);

    require(totalAllowedFreeze >= totalFreezed.add(_value)); //锁仓总额不能超过上限

    FreezeData storage freezeData = freezeDatas[_investor];

    require(freezeData.amount == 0); //已经参加过锁仓的地址不要进行锁仓

    freezeData.balance = freezeData.balance.add(_value);

    freezeData.amount = freezeData.amount.add(_value);

    totalFreezed = totalFreezed.add(_value);

    freezedWallets.push(_investor); //添加进锁仓地址列表

    emit Freeze(_investor, _value);

    return true;
}
