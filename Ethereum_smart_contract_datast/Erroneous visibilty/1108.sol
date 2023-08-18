function Ownable() {
    owner = msg.sender;
}

function setTier(address _tier) onlyOwner {
    assert(_tier != address(0));
    assert(tier == address(0));
    tier = _tier;
}

function FlatPricingExt(uint _oneTokenInWei) onlyOwner {
    require(_oneTokenInWei > 0);
    oneTokenInWei = _oneTokenInWei;
}

function updateRate(uint newOneTokenInWei) onlyTier {
    oneTokenInWei = newOneTokenInWei;
    RateChanged(newOneTokenInWei);
}
