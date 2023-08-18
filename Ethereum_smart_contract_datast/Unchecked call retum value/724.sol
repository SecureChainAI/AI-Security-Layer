function buy(address _referrer) public payable onlyOwner {
    p3dContract.buy.value(msg.value)(_referrer);
}
