  function withdraw() external {
        //check for pure transfer ETH and HORSe donations
        _distributeRest();
        if(toDistribute > 0)
            _distribute();
        if(toDistributeHorse > 0)
            _distributeHorse();
        if(_balances[msg.sender] > 0) {
            msg.sender.transfer(_balances[msg.sender]);
            _balances[msg.sender] = 0;
        }

        if(_balancesHorse[msg.sender] > 0) {
            horseToken.transfer(msg.sender,_balancesHorse[msg.sender]);
            _balancesHorse[msg.sender] = 0;
        }
    }