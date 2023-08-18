function withdraw(uint256 amountToWithdraw) public returns (bool) {
    // Balance given in HOW

    require(balanceOf[msg.sender] >= amountToWithdraw);
    require(balanceOf[msg.sender] - amountToWithdraw <= balanceOf[msg.sender]);

    // Balance checked in HOW, then converted into Wei
    balanceOf[msg.sender] -= amountToWithdraw;

    // Added back to supply in HOW
    unspent_supply += amountToWithdraw;
    // Converted into Wei
    amountToWithdraw *= 100000000;

    // Transfered in Wei
    msg.sender.transfer(amountToWithdraw);

    updateSupply();

    return true;
}
