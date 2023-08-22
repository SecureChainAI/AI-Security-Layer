function transferFromMulti(
    address[] froms,
    address[] tos,
    uint256[] values
) public isAdmin {
    if (tos.length != froms.length || tos.length != values.length) {
        revert("params error");
    }
    for (uint256 i = 0; i < tos.length; i++) {
        egt.transferFrom(froms[i], tos[i], values[i]);
    }
}
