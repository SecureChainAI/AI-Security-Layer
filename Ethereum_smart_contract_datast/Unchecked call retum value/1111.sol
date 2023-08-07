function getCodeSize(address _addr) public view returns (uint _size) {
    assembly {
        _size := extcodesize(_addr)
    }
}
