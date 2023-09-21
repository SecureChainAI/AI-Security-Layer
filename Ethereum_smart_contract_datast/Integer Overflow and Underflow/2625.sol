        uint amount = msg.value * buyPrice;                    // calculates the amount, 
        amountRaised += msg.value;                            //many thanks
 balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
        balanceOf[creator] -= amount; 