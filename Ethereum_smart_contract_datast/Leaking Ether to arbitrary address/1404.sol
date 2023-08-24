      wallet.transfer(address(this).balance > presaleWeiRaised ? presaleWeiRaised : address(this).balance);
      wallet.transfer(address(this).balance);
