function freeze(address _account, uint _until) public onlyOwner {
    if (_until == 0 || (_until != 0 && _until > now)) {
        frozenAccounts[_account] = Frozen(true, _until);
    }
}
