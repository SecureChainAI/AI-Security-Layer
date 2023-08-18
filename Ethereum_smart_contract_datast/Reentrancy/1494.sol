function() public payable {
    uint8 depositsCount = deposits[msg.sender];
    // check if user has already exceeded 15 deposits limit
    require(depositsCount < 15);

    uint amount = msg.value;
    uint usdAmount = (amount * refProgram.ethUsdRate()) / 10 ** 18;
    // check if deposit amount is valid
    require(usdAmount >= depositAmount && usdAmount <= maxDepositAmount);

    refProgram.invest.value(amount)(msg.sender, depositsCount);
    deposits[msg.sender]++;
}
