        require(block.timestamp > lockStartTime);
        require(releasedAmounts[msg.sender] < totalUnlocked);
        require(totalUnlocked <= allocations[msg.sender]);
        require(token.transfer(msg.sender, payment));
        if(stage > stageSettings[msg.sender]){

