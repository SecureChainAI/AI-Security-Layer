function PUCOINToken(address _admin, uint _totalTokenAmount) {
    // assign the admin account
    admin = _admin;

    // assign the total tokens to PUCOIN
    totalSupply = _totalTokenAmount;
    balances[msg.sender] = _totalTokenAmount;
    Transfer(address(0x0), msg.sender, _totalTokenAmount);
}
