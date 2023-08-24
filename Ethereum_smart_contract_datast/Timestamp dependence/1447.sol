        require(_start > now);
        require(unreleased > 0);
        if (now < cliff) {
        } else if (now >= start.add(duration)) {
        require(now >= canSelfDestruct);
