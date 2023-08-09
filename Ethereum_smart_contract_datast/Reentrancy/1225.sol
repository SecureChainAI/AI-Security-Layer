function endround() public isactivity(roundid) {
    require(
        now > rounds[roundid].end && rounds[roundid].lastvoter != address(0)
    );

    uint256 reward = rounds[roundid].jackpot;

    for (uint i = 0; i < players.length; i++) {
        address player = players[i];

        uint256 selfbalance = selfcommission[msg.sender] +
            selfharvest[msg.sender] +
            selfpotprofit[msg.sender];

        uint256 endreward = reward.mul(42).div(100).mul(selfvotes[player]).div(
            rounds[roundid].tickets
        );

        selfcommission[player] = 0;

        selfharvest[player] = 0;

        selfpotprofit[player] = 0;

        selfvoteamount[player] = 0;

        selfvotes[player] = 0;

        player.transfer(endreward.add(selfbalance));
    }

    rounds[roundid].lastvoter.transfer(reward.mul(48).div(100));

    tonextround = reward.mul(10).div(100);

    uint256 remainingpot = rounds[roundid].pot;

    tonextround = tonextround.add(remainingpot);

    rounds[roundid].active = false;

    delete players;
    players.length = 0;

    startRound();
}
