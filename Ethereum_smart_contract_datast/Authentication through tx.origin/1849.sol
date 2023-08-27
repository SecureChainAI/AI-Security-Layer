function swapCardForReward(
    address _by,
    uint8 _rank
) public onlyCard whenNotPaused returns (uint256) {
    // This is becaue we need to use tx.origin here.
    // _by should be the beneficiary, but due to the bug that is already exist with CryptoSagaCard.sol,
    // tx.origin is used instead of _by.
    require(tx.origin != _by && tx.origin != msg.sender);

    // Get value 0 ~ 9999.
    var _randomValue = random(10000, 0);

    // We hard-code this in order to give credential to the players.
    uint8 _heroRankToMint = 0;

    if (_rank == 0) {
        // Origin Card. 85% Heroic, 15% Legendary.
        if (_randomValue < 8500) {
            _heroRankToMint = 3;
        } else {
            _heroRankToMint = 4;
        }
    } else if (_rank == 3) {
        // Dungeon Chest card.
        if (_randomValue < 6500) {
            _heroRankToMint = 1;
        } else if (_randomValue < 9945) {
            _heroRankToMint = 2;
        } else if (_randomValue < 9995) {
            _heroRankToMint = 3;
        } else {
            _heroRankToMint = 4;
        }
    } else {
        // Do nothing here.
        _heroRankToMint = 0;
    }

    // Summon the hero.
    return summonHero(tx.origin, _heroRankToMint);
}
