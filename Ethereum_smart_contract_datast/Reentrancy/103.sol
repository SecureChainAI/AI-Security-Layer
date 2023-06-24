address public ethFundDeposit; 
function transferETH() external isOwner {
    if (this.balance == 0) throw;
    if (!ethFundDeposit.send(this.balance)) throw;
}
