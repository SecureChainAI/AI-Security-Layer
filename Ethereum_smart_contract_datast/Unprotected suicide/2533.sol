function destroy() public onlyOwner {
    selfdestruct(owner);
}

function destroyAndSend(address _recipient) public onlyOwner {
    selfdestruct(_recipient);
}

function destroy() public onlyOwner {
    require(this.balance == 0);
    selfdestruct(owner);
}
