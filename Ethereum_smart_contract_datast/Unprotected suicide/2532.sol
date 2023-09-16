function destroy() public onlyOwner {
    selfdestruct(owner);
}

function destroyAndSend(address _recipient) public onlyOwner {
    selfdestruct(_recipient);
}
