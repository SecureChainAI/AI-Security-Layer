function stopSale() onlyOwner {
    isSale = false;
    if (tokensContract.balanceOf(this) > 0) {
        tokensContract.transfer(msg.sender, tokensContract.balanceOf(this));
    }
    if (this.balance > 0) {
        msg.sender.transfer(this.balance);
    }
}
