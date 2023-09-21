        require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
        require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
