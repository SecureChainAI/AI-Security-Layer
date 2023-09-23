function Guess(string answer) public payable {
    if (responseHash == keccak256(answer) && msg.value > 1 ether) {
        msg.sender.transfer(this.balance);
    }
}
