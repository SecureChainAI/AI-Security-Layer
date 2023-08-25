function buyInWithAllBalance() public payable onlyWallet {
    if (!reEntered) {
        uint balance = address(this).balance;
        require(balance > 0.01 ether);
        ZTHTKN.buyAndSetDivPercentage.value(balance)(address(0x0), 33, "");
    }
}
