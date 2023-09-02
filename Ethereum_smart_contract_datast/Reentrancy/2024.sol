function() external payable {
    require(msg.sender != ETHFund);
    require(stages[stages.length - 1].state != StageState.Done);
    require(msg.value > 0);
    require(
        stages[curStage].authOnly <=
            stages[curStage].contributors[msg.sender].authorized
    );

    uint256 refundAmount;
    uint256 funds;
    (funds, refundAmount) = ExchangeRate(msg.value);
    assert(refundAmount < msg.value);
    msg.sender.transfer(refundAmount);
    ETHFund.transfer(msg.value - refundAmount);
    addFunds(funds, msg.sender);
}
