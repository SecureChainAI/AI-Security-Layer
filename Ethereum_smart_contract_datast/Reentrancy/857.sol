function burn(uint256 _value) public returns (bool success) {
    //检查帐户余额是否大于要减去的值
    require(balanceOf[msg.sender] >= _value); // Check if the sender has enough

    //给指定帐户减去余额
    balanceOf[msg.sender] -= _value;

    //代币问题做相应扣除
    totalSupply -= _value;

    Burn(msg.sender, _value);
    return true;
}
