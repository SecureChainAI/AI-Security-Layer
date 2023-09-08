        require(medalUnlockTime[msg.sender] < uint(now));
        require(unlockTime[msg.sender] < uint(now));
        require(MemberToTime[msg.sender] < uint(now)); 
