 function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
    if(isContract(_to)) {
      require(beingEdited[_to] != true && beingEdited[msg.sender] != true);
      //make sure the sender has enough coins to transfer
      require (balances[msg.sender] >= _value); 
      setEditedTrue(_to);
      setEditedTrue(msg.sender);
      //transfer the coins
      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
      balances[_to] = SafeMath.add(balances[_to], _value);
      assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
      emit Transfer(msg.sender, _to, _value, _data); //log the transfer
      setEditedFalse(_to);
      setEditedFalse(msg.sender);
      updateAddresses(_to);
      updateAddresses(msg.sender);
      return true;
    }
    else {
      return transferToAddress(_to, _value, _data);
    }
  }