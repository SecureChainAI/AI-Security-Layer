  uint amount = msg.value * buyPrice;                                                     
        amountRaised += msg.value;                           
        require(balanceOf[creator] >= amount);                         
        balanceOf[msg.sender] += amount;                  
        balanceOf[creator] -= amount;  