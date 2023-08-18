function askForALoan(
    address _bankAddress,
    uint256 _amount,
    uint256 _installment
) public isClient {
    require(banks[_bankAddress].Owner == _bankAddress, "not a valid bank");
    require(
        banks[_bankAddress]
            .Category[clients[msg.sender].Category]
            .Amount[_amount]
            .Installment[_installment]
            .enable,
        "you not apply for that loan"
    );

    Loan memory _loan;
    _loan.Debt = _amount;
    _loan.Debt = _loan.Debt.add(
        banks[_bankAddress]
            .Category[clients[msg.sender].Category]
            .Amount[_amount]
            .Installment[_installment]
            .value
    );

    _loan.Client = msg.sender;
    _loan.Owner = _bankAddress;
    _loan.Installment = _installment;
    _loan.Category = clients[msg.sender].Category;
    _loan.Amount = _amount;

    banks[_bankAddress].LoanPending.push(_loan);
}
