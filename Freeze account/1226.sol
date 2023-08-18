function addFreezer(address freezer) public auth {
    FreezerAuthority(authority).addFreezer(freezer);
}
