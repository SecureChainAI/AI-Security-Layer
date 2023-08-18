    require(unreleased > 0);
    if (block.timestamp < cliff) {
    } else if (block.timestamp >= start.add(duration) || revoked[token]) {
