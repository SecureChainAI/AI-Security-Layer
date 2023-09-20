function setStartsAt(uint time) onlyOwner {
    assert(!finalized);
    assert(isUpdatable);
    assert(now <= time); // Don't change past
    assert(time <= endsAt);
    assert(now <= startsAt);

    CrowdsaleExt lastTierCntrct = CrowdsaleExt(getLastTier());
    if (lastTierCntrct.finalized()) throw;

    uint8 tierPosition = getTierPosition(this);

    //start time should be greater then end time of previous tiers
    for (uint8 j = 0; j < tierPosition; j++) {
        CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
        assert(time >= crowdsale.endsAt());
    }

    startsAt = time;
    StartsAtChanged(startsAt);
}
