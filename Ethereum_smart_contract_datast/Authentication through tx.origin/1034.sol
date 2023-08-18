modifier onlyRealPeople()
    {
          require (msg.sender == tx.origin);
        _;
    }