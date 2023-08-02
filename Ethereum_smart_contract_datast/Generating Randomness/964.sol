function random() private view returns (uint) {
    return
        uint(
            keccak256(
                abi.encodePacked(block.difficulty, now, msg.sender, players)
            )
        );
}

function RandomWinner() private {
    if (players.length < MaxPlayers) revert();
    uint256 fee = SafeMath.div(address(this).balance, 100);
    lastWinner = players[random() % players.length];

    lastWinner.transfer(address(this).balance - fee);
    owner.transfer(fee);
    delete players;
    jackpot = 0;

    completedGames++;
}
