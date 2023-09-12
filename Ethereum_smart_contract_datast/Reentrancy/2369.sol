function sell(uint256 amount) public {
    require(this.balance >= amount * sellPrice); // checks if the contract has enough ether to buy
    _transfer(msg.sender, this, amount); // makes the transfers
    msg.sender.transfer(amount * sellPrice); // sends ether to the seller. It's important to do this last to avoid recursion attacks
}
