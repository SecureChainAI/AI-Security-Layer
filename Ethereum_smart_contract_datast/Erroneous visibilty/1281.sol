function withdraw() onlyOwner {
    assert(this.balance > 0);
    msg.sender.transfer(this.balance);
}

function stopSale() onlyOwner {
    isSale = false;
    if (tokensContract.balanceOf(this) > 0) {
        tokensContract.transfer(msg.sender, tokensContract.balanceOf(this));
    }
    if (this.balance > 0) {
        msg.sender.transfer(this.balance);
    }
}

function SaleTokens() {
    tokensContract = SmartRouletteToken(
        0xdca4ea5f5c154c4feaf22a38ecafb8c71dad816d
    );
    isSale = true;
    minInvest = 0.01 ether;
}

function stopSale() onlyOwner {
    isSale = false;
    if (tokensContract.balanceOf(this) > 0) {
        tokensContract.transfer(msg.sender, tokensContract.balanceOf(this));
    }
    if (this.balance > 0) {
        msg.sender.transfer(this.balance);
    }
}
