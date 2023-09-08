  if (now <= countdownDate + (180 * 1 days)) {return lockedAmt;}
        if (now <= countdownDate + (180 * 2 days)) {return lockedAmt.mul(7).div(8);}
        if (now <= countdownDate + (180 * 3 days)) {return lockedAmt.mul(6).div(8);}
        if (now <= countdownDate + (180 * 4 days)) {return lockedAmt.mul(5).div(8);}
        if (now <= countdownDate + (180 * 5 days)) {return lockedAmt.mul(4).div(8);}
        if (now <= countdownDate + (180 * 6 days)) {return lockedAmt.mul(3).div(8);}
        if (now <= countdownDate + (180 * 7 days)) {return lockedAmt.mul(2).div(8);}
        if (now <= countdownDate + (180 * 8 days)) {return lockedAmt.mul(1).div(8);}
  if (now <= delieveryDate) {return lockedAmt;}
        if (now <= delieveryDate + 90 days) {return lockedAmt.mul(2).div(3);}
        if (now <= delieveryDate + 180 days) {return lockedAmt.mul(1).div(3);}
	
