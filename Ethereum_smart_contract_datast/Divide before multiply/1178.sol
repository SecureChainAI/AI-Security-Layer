function sellPBTTAgainstEther(
    uint256 amount
) private returns (uint256 revenue) {
    // Avoid selling and spam
    require(sellPriceEth > 0, "sellPriceEth must be > 0");

    require(
        amount >= PBTTForGas,
        "Sell token amount must be larger than PBTTForGas value"
    );

    // Check if the sender has enough to sell
    require(
        balances[msg.sender] >= amount,
        "Token balance is not enough to sold"
    );

    require(
        msg.sender.balance >= minBalanceForAccounts,
        "Seller balance must be enough to pay the transaction fee"
    );

    // Revenue = eth that will be send to the user
    revenue = (amount.div(DECIMALSFACTOR)).mul(sellPriceEth);

    // Keep min amount of eth in contract to provide gas for transactions
    uint256 remaining = address(this).balance.sub(revenue);
    require(
        remaining >= gasReserve,
        "Remaining contract balance is not enough for reserved"
    );

    // Add the token amount to owner balance
    balances[owner] = balances[owner].add(amount);
    // Subtract the amount from seller's token balance
    balances[msg.sender] = balances[msg.sender].sub(amount);

    // transfer eth
    // 'msg.sender.transfer' means the contract sends ether to 'msg.sender'
    // It's important to do this last to avoid recursion attacks
    msg.sender.transfer(revenue);

    // Execute an event reflecting on the change
    emit Transfer(msg.sender, owner, amount);
    return revenue;
}
