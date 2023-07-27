function transfer(
    address token,
    address owner,
    address[] to,
    uint[] value
) public {
    require(to.length == value.length);
    require(token != address(0));

    ERC20 t = ERC20(token);
    for (uint i = 0; i < to.length; i++) {
        t.transferFrom(owner, to[i], value[i]);
    }
}
