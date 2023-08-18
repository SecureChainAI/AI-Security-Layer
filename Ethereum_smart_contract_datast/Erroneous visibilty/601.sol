function ApolloCoinToken(
    uint tokenTotalAmount,
    uint _transferableStartTime,
    address _admin,
    address _earlyInvestorWallet
) {
    // Mint total supply and permanently disable minting
    totalSupply = tokenTotalAmount * (10 ** uint256(decimals));

    balances[msg.sender] = totalSupply;
    Transfer(address(0x0), msg.sender, totalSupply);

    transferableStartTime = _transferableStartTime; // tokens may only be transferred after this time
    tokenSaleContract = msg.sender;
    earlyInvestorWallet = _earlyInvestorWallet;

    transferOwnership(_admin);
}

function ApolloCoinTokenSale(
    uint256 _icoStartTime,
    uint256 _presaleStartTime,
    uint256 _presaleEndTime
)
    WhitelistedCrowdsale
    CappedCrowdsale(HARD_CAP)
    StandardCrowdsale(
        _icoStartTime,
        _presaleStartTime,
        _presaleEndTime,
        ICO_RATE,
        TIER1_RATE,
        TIER2_RATE,
        TIER3_RATE,
        TIER4_RATE,
        APOLLOCOIN_COMPANY_WALLET
    )
{
    token.transfer(TEAM_WALLET, TEAM_AMOUNT);

    token.transfer(EARLY_INVESTOR_WALLET, EARLY_INVESTOR_AMOUNT);

    token.transfer(APOLLOCOIN_COMPANY_WALLET, APOLLOCOIN_COMPANY_AMOUNT);
}
