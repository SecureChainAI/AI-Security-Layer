function transfer(address _to, uint256 _value) public onlyOwner {
    require(_value > 0);
    like.transfer(_to, _value);
}
