            mirrors[winnerTimestamp][i].transfer(share.mul(9).div(10));
        share = share.div(countSecondWinners);
            referral[mirrors[winnerTimestamp][i]].transfer(share.mul(1).div(10));
            mirrors[secondWinnerTimestamp][i].transfer(share.mul(9).div(10));
            referral[mirrors[secondWinnerTimestamp][i]].transfer(share.mul(1).div(10));
