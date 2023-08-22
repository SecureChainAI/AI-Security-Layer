function purchase(
    address payout,
    address referrer
) public payable icoOnly returns (uint tokens) {
    Fraction memory bonus = _getBonus();

    // Calculate the raw amount of tokens:
    uint rawTokens = msg.value.mul(_basePrice.d).div(_basePrice.n);
    // Calculate the amount of tokens including bonus:
    tokens = rawTokens + rawTokens.mul(bonus.n).div(bonus.d);
    // Calculate the amount of tokens for the referrer:
    uint refTokens = rawTokens.mul(_refBonus.n).div(_refBonus.d);

    // Transfer tokens to the payout address:
    _drupe.transfer(payout, tokens);
    // Transfer ref bonus tokens to the referrer:
    _drupe.transfer(referrer, refTokens);
    // (Sent Ether will remain on this contract)

    // Create referral contract for the sender:
    address refContract = new DrupeICORef(payout, this);
    emit Referrer(payout, refContract);
}
