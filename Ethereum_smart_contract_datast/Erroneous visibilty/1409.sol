function ZClassicGold() {
    totalSupply = 500000000000000;
    symbol = "ZCLG";
    owner = 0x1a888Db785f43222ee7Ad9774f9e94ba5574D666;
    balances[owner] = 500000000000000;
    decimals = 8;
}

function unlockSupply() returns (bool) {
    require(msg.sender == owner);
    require(!fullSupplyUnlocked);
    balances[owner] = balances[owner].add(0);
    fullSupplyUnlocked = true;
    return true;
}
