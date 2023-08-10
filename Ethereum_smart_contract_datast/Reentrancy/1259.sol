function claim_reward() external afterRace {
    require(!voterIndex[msg.sender].rewarded);
    uint transfer_amount = calculateReward(msg.sender);
    require(address(this).balance >= transfer_amount);
    voterIndex[msg.sender].rewarded = true;
    msg.sender.transfer(transfer_amount);
    emit Withdraw(msg.sender, transfer_amount);
}
