  modifier notContract() {
      require (msg.sender == tx.origin);
      _;
    }