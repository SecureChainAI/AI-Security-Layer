function _lockToken(address addr,uint expireTime) public payable returns (bool) {
    require(msg.sender == owner);
    for(uint i = 0; i < lockholderNumber; i++) {
      if (lockholders[i].eth_address == addr) {
          lockholders[i].exp_time = expireTime;
        return true;
      }
    }
    lockholders[lockholderNumber]=Holder(addr,expireTime);
    lockholderNumber++;
    return true;
  }
  
function _unlockToken(address addr) public payable returns (bool){
    require(msg.sender == owner);
    for(uint i = 0; i < lockholderNumber; i++) {
      if (lockholders[i].eth_address == addr) {
          delete lockholders[i];
        return true;
      }
    }
    return true;
  }
