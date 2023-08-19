function distributeReservedTokens(uint reservedTokensDistributionBatch);

/** Called once by crowdsale finalize() if the sale was success. */
function finalizeCrowdsale();

function CrowdsaleExt(
    string _name,
    address _token,
    PricingStrategy _pricingStrategy,
    address _multisigWallet,
    uint _start,
    uint _end,
    uint _minimumFundingGoal,
    bool _isUpdatable,
    bool _isWhiteListed
) {
    owner = msg.sender;

    name = _name;

    token = FractionalERC20Ext(_token);

    setPricingStrategy(_pricingStrategy);

    multisigWallet = _multisigWallet;
    if (multisigWallet == 0) {
        throw;
    }

    if (_start == 0) {
        throw;
    }

    startsAt = _start;

    if (_end == 0) {
        throw;
    }

    endsAt = _end;

    // Don't mess the dates
    if (startsAt >= endsAt) {
        throw;
    }

    // Minimum funding goal can be zero
    minimumFundingGoal = _minimumFundingGoal;

    isUpdatable = _isUpdatable;

    isWhiteListed = _isWhiteListed;
}
