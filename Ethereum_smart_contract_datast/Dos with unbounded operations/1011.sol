function getTransfer(bytes32 _password, uint256 _number) public {
    require(password[sha3(_password, _number)].amount > 0);

    bytes32 pass = sha3(_password, _number);
    address from = password[pass].from;
    uint256 amount = password[pass].amount;
    amount = amount.sub(commissionFee);
    totalFee = totalFee.add(commissionFee);

    _updateSeed();

    password[pass].amount = 0;

    msg.sender.transfer(amount);

    emit LogGetTransfer(from, msg.sender, amount);
}
