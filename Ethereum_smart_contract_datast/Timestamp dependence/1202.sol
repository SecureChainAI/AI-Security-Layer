    require(unreleased > 0);
    if (now < cliff) {
    } else if (now >= start.add(duration) || revoked[token]) {
        if (now < cliff) {
        } else if (now >= start.add(duration * periods) || revoked[token]) {
            if (periodsOver >= periods) {
