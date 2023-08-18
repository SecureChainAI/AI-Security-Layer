function withdraw(uint withdrawAmount) public {
    if (balances[msg.sender] >= withdrawAmount) {
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
    }
}
