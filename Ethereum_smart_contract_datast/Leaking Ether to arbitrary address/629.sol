function registerNameCore(
    uint256 _pID,
    address _addr,
    uint256 _affID,
    bytes32 _name,
    bool _isNewPlayer,
    bool _all
) private {
    if (pIDxName_[_name] != 0)
        require(plyrNames_[_pID][_name] == true, "Name Already Exist!");

    plyr_[_pID].name = _name;
    pIDxName_[_name] = _pID;
    if (plyrNames_[_pID][_name] == false) {
        plyrNames_[_pID][_name] = true;
        plyr_[_pID].names++;
        plyrNameList_[_pID][plyr_[_pID].names] = _name;
    }

    cfo.transfer(address(this).balance);

    if (_all == true)
        for (uint256 i = 1; i <= gID_; i++)
            games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);

    emit onNewName(
        _pID,
        _addr,
        _name,
        _isNewPlayer,
        _affID,
        plyr_[_affID].addr,
        plyr_[_affID].name,
        msg.value,
        now
    );
}
