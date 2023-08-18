function() public {
    require(msg.sender == tx.origin, "msg.sender == tx.orgin");

    uint256 xcc_amount = xcc.balanceOf(msg.sender);
    require(xcc_amount > 0, "xcc_amount > 0");

    uint256 money = refunds[msg.sender];
    require(money > 0, "money > 0");

    refunds[msg.sender] = 0;

    xcc.originBurn(xcc_amount);
    msg.sender.transfer(money);
}
