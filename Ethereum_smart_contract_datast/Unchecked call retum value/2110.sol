function pauseGame(bool _status) public onlyOwner returns (bool) {
    gamePaused = _status;
    emit pauseGameEvt(_status);
}

function setOdds(uint _odds) public isHuman onlyOwner returns (bool) {
    odds = _odds;
    emit setOddsEvt(_odds);
}

function setReservefund(
    uint _reservefund
) public isHuman onlyOwner returns (bool) {
    reservefund = _reservefund * 1 ether;
}
