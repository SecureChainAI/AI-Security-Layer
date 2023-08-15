function doWithdrawal(address beneficiary, uint amount) private {
    require(beneficiary != 0x0);
    beneficiary.transfer(amount);
}
