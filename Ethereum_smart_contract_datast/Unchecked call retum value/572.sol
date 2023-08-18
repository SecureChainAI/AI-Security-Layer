function transferMulti(address[] tos, uint256[] values) public isAdmin {
    if (tos.length != values.length) {
        revert("params error");
    }
    for (uint256 i = 0; i < tos.length; i++) {
        egt.transfer(tos[i], values[i]);
    }
}
