function claim(ERC20Basic _token, address _to) public onlyOwner {
    if (_token == address(0)) {
        _to.transfer(address(this).balance - totalReward);
    } else {
        _token.transfer(_to, _token.balanceOf(this));
    }
}
