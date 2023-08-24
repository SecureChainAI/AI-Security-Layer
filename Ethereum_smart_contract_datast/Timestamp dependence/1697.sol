    assert(now <= endsAt);
    assert(now <= endsAt);
    assert(now <= endsAt);
    assert(now <= time); // Don't change past
    assert(now <= startsAt);
    assert(now <= time);// Don't change past
    assert(now <= endsAt);
   else if (block.timestamp < startsAt) return State.PreFunding;
    else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
    assert(now <= startsAt);
    assert(now <= startsAt);
