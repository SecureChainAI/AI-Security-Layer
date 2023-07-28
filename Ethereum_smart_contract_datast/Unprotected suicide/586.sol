function kill() public isOwner {
    // Too much money involved to not have a fire exit
    selfdestruct(fundsWallet);
}
