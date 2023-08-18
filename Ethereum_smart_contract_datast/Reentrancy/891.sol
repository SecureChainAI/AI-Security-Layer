function() payable {
    totalEthInWei = totalEthInWei + msg.value;
    uint256 amount = msg.value * unitsOneEthCanBuy;
    require(balances[fundsWallet] >= amount);

    balances[fundsWallet] = balances[fundsWallet] - amount;
    balances[msg.sender] = balances[msg.sender] + amount;

    emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain

    //Transfer ether to fundsWallet
    fundsWallet.transfer(msg.value);
}
