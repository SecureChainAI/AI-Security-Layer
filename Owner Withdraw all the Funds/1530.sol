function safeWithdrawal(uint _value) public onlyOwner {
    if (_value == 0) owner.transfer(address(this).balance);
    else owner.transfer(_value);
}
