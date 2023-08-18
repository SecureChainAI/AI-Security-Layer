  function Token()
        public
        payable
        
    {
        
                uint premintAmount = 10000000*10**uint(decimals);
                totalSupply_ = totalSupply_.add(premintAmount);
                balances[msg.sender] = balances[msg.sender].add(premintAmount);
                Transfer(address(0), msg.sender, premintAmount);

            
        
    }