function transfer(address[] to, uint[] value) public onlyOwner {
    require(to.length == value.length);

    for (uint i = 0; i < to.length; i++) {
        tkcAddress.transferFrom(owner, to[i], value[i]);
    }
}
