function addOwner(address _who) public onlyOwner returns (bool) {
    _setOwner(_who, true);
}

function deleteOwner(address _who) public onlyOwner returns (bool) {
    _setOwner(_who, false);
}

function addMinter(address _who) public onlyOwner returns (bool) {
    _setMinter(_who, true);
}
