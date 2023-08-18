function lockToken() public onlyOwner {
    require(released);
    released = false;
    emit ReleaseToken(msg.sender, released);
}
