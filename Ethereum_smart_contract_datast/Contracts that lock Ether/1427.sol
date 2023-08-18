function lock(address[] _addr) external onlyOwner {
    for (uint i = 0; i < _addr.length; i++) {
        balanceLocked[_addr[i]] = true;
    }
}
