 require(_value > 0
                && frozenAccount[msg.sender] == false
                && frozenAccount[_to] == false
                && now > unlockUnixTime[msg.sender]
                && now > unlockUnixTime[_to]);
 require(_value > 0
                && frozenAccount[msg.sender] == false
                && frozenAccount[_to] == false
                && now > unlockUnixTime[msg.sender]
                && now > unlockUnixTime[_to]);
 require(_value > 0
                && frozenAccount[msg.sender] == false
                && frozenAccount[_to] == false
                && now > unlockUnixTime[msg.sender]
                && now > unlockUnixTime[_to]);
 require(_to != address(0)
                && _value > 0
                && balanceOf[_from] >= _value
                && allowance[_from][msg.sender] >= _value
                && frozenAccount[_from] == false
                && frozenAccount[_to] == false
                && now > unlockUnixTime[_from]
                && now > unlockUnixTime[_to]);
 require(amount > 0 
                && addresses.length > 0
                && frozenAccount[msg.sender] == false
                && now > unlockUnixTime[msg.sender]);
  require(addresses[j] != 0x0
                    && frozenAccount[addresses[j]] == false
                    && now > unlockUnixTime[addresses[j]]);
 require(addresses.length > 0
                && addresses.length == amounts.length
                && frozenAccount[msg.sender] == false
                && now > unlockUnixTime[msg.sender]);
 require(amounts[j] > 0
                    && addresses[j] != 0x0
                    && frozenAccount[addresses[j]] == false
                    && now > unlockUnixTime[addresses[j]]);
  require(amounts[j] > 0
                    && addresses[j] != 0x0
                    && frozenAccount[addresses[j]] == false
                    && now > unlockUnixTime[addresses[j]]);
  require(distributeAmount > 0
                && balanceOf[owner] >= distributeAmount
                && frozenAccount[msg.sender] == false
                && now > unlockUnixTime[msg.sender]);