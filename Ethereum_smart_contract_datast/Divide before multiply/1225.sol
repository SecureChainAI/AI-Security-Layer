function getBonus() public view returns (uint256) {
    return
        (selfvotes[msg.sender] / rounds[roundid].tickets) *
        rounds[roundid].jackpot;
}
