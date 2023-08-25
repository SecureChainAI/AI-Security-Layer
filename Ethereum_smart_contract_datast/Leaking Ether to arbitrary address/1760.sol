function Answer(string answer) public payable {
    if (responseHash == keccak256(answer) && msg.value > 1 ether) {
        msg.sender.transfer(address(this).balance);
    }
}
