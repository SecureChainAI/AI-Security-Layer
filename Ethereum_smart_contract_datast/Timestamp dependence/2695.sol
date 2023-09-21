         require(now > lockup_enddate);
             require(now > lockup_enddate);
             if(now >= transferPostDate + transferDaysTotal) {
  require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercent)).div(100));
             require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercentTotal)).div(100));
             require(now >= transferLastTransaction + transferDays);
             require((transferTotalSpent * 10 ** 18) <= ((_totalsupply).mul(transferPercentTotal)).div(100));
             require(now <= transferPostDate + transferDaysTotal);
             require(now > lockup_enddate);
      require((_amount * 10 ** 18) <= ((_totalsupply).mul(transferPercent)).div(100));    
             require(now >= transferLastTransaction + transferDays);

