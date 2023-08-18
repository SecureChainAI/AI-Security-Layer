function play() public isOpenToPublic onlyRealPeople onlyPlayers {
    uint256 blockNumber = timestamps[msg.sender];
    if (blockNumber < block.number) {
        timestamps[msg.sender] = 0;
        wagers[msg.sender] = 0;

        uint256 winningNumber = (uint256(
            keccak256(abi.encodePacked(blockhash(blockNumber), msg.sender))
        ) % difficulty) + 1;

        if (winningNumber == difficulty / 2) {
            payout(msg.sender);
        } else {
            //player loses
            loseWager(betLimit / 2);
        }
    } else {
        revert();
    }
}
