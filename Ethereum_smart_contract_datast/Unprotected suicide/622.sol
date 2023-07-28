function destroy(address _address) public onlyOwner {
    selfdestruct(_address);
}
