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