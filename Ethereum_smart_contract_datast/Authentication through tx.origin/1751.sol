function Vault() public payable {
    if (msg.sender == tx.origin) {
        Owner = msg.sender;
        deposit();
    }
}
