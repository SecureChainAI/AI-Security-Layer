  function doExchange (uint exchangeId) external payable returns (bool success) {
         //re-entry defense
        bool _locked;
        require(!_locked);
        _locked = true;
        require(msg.value>=206000000);
        if (exchanges[exchangeId].two2!=0x1111111111111111111111111111111111111111){
        require(msg.sender==exchanges[exchangeId].two2);
        } else {
        exchanges[exchangeId].two2=msg.sender;    
        }
   
        require(exchanges[exchangeId].DealDone==false);
        require(exchanges[exchangeId].amount2>0);
       
        if (exchanges[exchangeId].smart2==address(0)) {
            
            require(msg.value >=206000000 + exchanges[exchangeId].amount2);
            require(payether(atokenaddress, msg.value - exchanges[exchangeId].amount2)==true);
        } else {
            require(payether(atokenaddress, msg.value)==true);
        }
       //party 2 move tokens to party 1
        if (exchanges[exchangeId].smart2==address(0)) {
            require(payether(exchanges[exchangeId].one1,exchanges[exchangeId].amount2)==true);
        } else {
            TCallee c= TCallee(exchanges[exchangeId].smart2);
            bool x=c.transferFrom(exchanges[exchangeId].two2, exchanges[exchangeId].one1, exchanges[exchangeId].amount2);
             require(x==true);
        }
      
      //party 1 moves tokens to party 2
      if (exchanges[exchangeId].smart1==address(0)) {
         require(payether(exchanges[exchangeId].two2, exchanges[exchangeId].amount1)==true);
         
    } else {
         TCallee d= TCallee(exchanges[exchangeId].smart1);
            bool y=d.transferFrom(exchanges[exchangeId].one1, exchanges[exchangeId].two2, exchanges[exchangeId].amount1);
             require(y==true);
      
      
    }
    exchanges[exchangeId].DealDone=true;
    emit DoExchange (exchangeId); 
    _locked=false;
    return true;
}
