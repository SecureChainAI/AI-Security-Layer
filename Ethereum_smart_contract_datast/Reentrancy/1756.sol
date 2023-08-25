function dumpFreeTokens(
    address stakeAddress
) public onlyDevOrBankroll returns (uint) {
    // First, allocate tokens
    allocateTokens();

    // Don't transfer tokens if we have less than 1 free token
    if (freeTokens < 1e18) {
        return 0;
    }

    // Transfer free tokens to bankroll
    ZethrContract.transfer(stakeAddress, freeTokens);

    // Set free tokens to zero
    uint sent = freeTokens;
    freeTokens = 0;

    // Return the number of tokens we sent
    return sent;
}
