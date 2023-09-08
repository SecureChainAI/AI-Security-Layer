  modifier notContract() {
      require (msg.sender == tx.origin);
      _;
    }
  function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
      notContract()// no contracts allowed
      internal
      returns(uint256) {

      uint256 purchaseEthereum = _incomingEthereum;
      uint256 excess;
      if(purchaseEthereum > 5 ether) { // check if the transaction is over 5 ether
          if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
              purchaseEthereum = 5 ether;
              excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
          }
      }