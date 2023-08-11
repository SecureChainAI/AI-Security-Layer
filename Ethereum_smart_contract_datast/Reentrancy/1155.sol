   function receiveDividends() public payable {
      if (!reEntered) {
        uint ActualBalance = (address(this).balance.sub(NonICOBuyins));
        if (ActualBalance > 0.01 ether) {
          reEntered = true;
          ZTHTKN.buyAndSetDivPercentage.value(ActualBalance)(address(0x0), 33, "");
          emit BankrollInvest(ActualBalance);
          reEntered = false;
        }
      }
    }