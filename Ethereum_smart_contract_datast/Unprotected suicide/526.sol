function BurnMe() {
    // Selfdestruct and send eth to self,
    selfdestruct(address(this));
}
