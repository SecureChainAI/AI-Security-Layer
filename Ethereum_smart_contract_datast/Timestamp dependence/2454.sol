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
   require(amount > 0
            && addresses.length > 0
            && frozenAccount[msg.sender] == false
            && now > unlockUnixTime[msg.sender]);
   require(addresses[i] != 0x0
              && frozenAccount[addresses[i]] == false
              && now > unlockUnixTime[addresses[i]]);
    require(amounts[i] > 0
              && addresses[i] != 0x0
              && frozenAccount[addresses[i]] == false
              && now > unlockUnixTime[addresses[i]]);
  require(distributeAmount > 0
            && balanceOf(owner) >= distributeAmount
            && frozenAccount[msg.sender] == false
            && now > unlockUnixTime[msg.sender]);
