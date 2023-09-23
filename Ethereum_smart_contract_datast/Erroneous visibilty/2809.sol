function testnetWithdrawn(address tokencontract, uint val) {
    require(msg.sender == owner);
    ERC20(tokencontract).transfer(msg.sender, val);
}
