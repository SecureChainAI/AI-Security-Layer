            uint timeTemp = (now - startTime) / 60 / 60 / 24 / 100;
            require(balances[msg.sender] - _value >= (totalSupply / 5 - totalSupply * timeTemp / 50));
