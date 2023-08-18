function MintableToken() {
    mint(msg.sender, 500000000 * (10 ** 18));
    finishMinting();
}
