function remove() checkAccess("owner") returns (bool) {
    if (isImmortal) {
        return false;
    }
    selfdestruct(msg.sender);
    return true;
}
