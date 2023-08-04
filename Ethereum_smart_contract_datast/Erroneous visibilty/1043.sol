function FlatPricingExt(uint _oneTokenInWei) onlyOwner {
    require(_oneTokenInWei > 0);
    oneTokenInWei = _oneTokenInWei;
}

function updateRate(uint newOneTokenInWei) onlyTier {
    oneTokenInWei = newOneTokenInWei;
    RateChanged(newOneTokenInWei);
}

function updateRate(uint newOneTokenInWei) onlyTier {
    oneTokenInWei = newOneTokenInWei;
    RateChanged(newOneTokenInWei);
}
