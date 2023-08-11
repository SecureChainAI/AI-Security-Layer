function withdrawFunds() public afterEnd {
    if (msg.sender == owner) {
        require(totalSold >= softCap);

        Beneficiary memory beneficiary = beneficiaries[0];
        beneficiary.wallet.transfer(address(this).balance);
    } else {
        require(totalSold < softCap);
        require(buyers[msg.sender] > 0);

        buyers[msg.sender] = 0;
        msg.sender.transfer(buyers[msg.sender]);
    }
}
