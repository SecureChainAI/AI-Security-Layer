function drawRandomWinner() public onlyAdmin {
    require(raffleEndTime < block.timestamp); //close it if need to test
    require(!raffleWinningTicketSelected);

    uint256 seed = SafeMath.add(raffleTicketsBought, block.timestamp);
    raffleTicketThatWon = addmod(
        uint256(block.blockhash(block.number - 1)),
        seed,
        raffleTicketsBought
    );
    raffleWinningTicketSelected = true;
}
