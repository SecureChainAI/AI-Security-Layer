        require(now >= registryStarted && now <= registryStarted + 4 years && ens.owner(rootNode) == address(this));
        require(address(bid) != 0 && now >= bid.creationDate() + totalAuctionLength + 2 weeks);
        require(now >= h.registrationDate + 1 years || ens.owner(rootNode) != address(this));
else if (now < entry.registrationDate) {
            if (now < entry.registrationDate - revealPeriod) {