      if (now >= CANCELATION_DATE) {
    return (completed && winningOption != 2 && now >= (winnerDeterminedDate + 600)); // At least 10 mins has to pass between determining winner and enabling payout, so that we have time to revert the bet in case we detect suspicious betting activty (eg. a hacker bets a lot to steal the entire losing pot, and hacks the oracle)
    return (now >= BETTING_OPENS && now < BETTING_CLOSES && !canceled && !completed);
    require(canBet() == true);
    require(now >= (winnerDeterminedDate + 600));
