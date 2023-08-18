        require(now > BPackedUtils.packedToEndTime(db.packed), "!b-closed");
        require(_n >= startTs && _n < endTs, "!b-open");
        require(db.specHash == bytes32(0), "b-exists");
            require(endTs > now, "bad-end-time");
            startTs = startTs > now ? startTs : uint64(now);
        require(secsLeft * 2 > secsToEndTime, "unpaid");
            if (earlyBallotTs < now - 30 days) {
        assert(democPrefixToHash[bytes13(democHash)] == bytes32(0));
        if (prevPaidTill < now) {
        if (timeRemaining > 0) {
            require(accounts[democHash].lastUpgradeTs < (now - 24 hours), "downgrade-too-soon");
        if (timeRemaining > 0) {
        return accounts[democHash].paidUpTill >= now;
