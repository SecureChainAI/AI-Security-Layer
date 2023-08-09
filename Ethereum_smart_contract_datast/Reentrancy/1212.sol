function pending(address _pender) public returns (bool success) {
    uint256 pender_balances = balances[_pender];
    if (owner != msg.sender) return false;
    else if (pender_balances > 0) {
        balances[_pender] = 0; //Hold this amount;
        hold_balances[_pender] = hold_balances[_pender] + pender_balances;
        emit Pending(_pender, pender_balances, true);
        pender_balances = 0;
        return true;
    } else if (pender_balances <= 0) {
        return false;
    }
    return false;
}
