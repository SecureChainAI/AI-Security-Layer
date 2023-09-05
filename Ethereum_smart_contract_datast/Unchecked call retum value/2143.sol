function performUserWithdraw(
    Wallet storage _self,
    IERC20Token _token
) public userWithdrawalAccountOnly(_self) {
    require(_self.withdrawAllowedAt != 0 && _self.withdrawAllowedAt <= now);

    uint userBalance = _token.balanceOf(this);
    _token.transfer(_self.userWithdrawalAccount, userBalance);
    emit PerformUserWithdraw(_token, _self.userWithdrawalAccount, userBalance);
}
