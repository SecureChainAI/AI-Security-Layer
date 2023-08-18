function withdraw(uint _amount) public onlyOwner {
    require(_amount > 0);
    require(_amount <= weiBalance); // Amount withdraw should be less or equal to balance
    if (owner.send(_amount)) {
        weiBalance -= _amount;
        emit Withdrawal(owner, _amount);
    } else {
        throw;
    }
}
