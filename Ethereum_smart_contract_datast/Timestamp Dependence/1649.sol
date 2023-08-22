function Put_DEDI_gift(address _reciver) public payable {
    if ((!closed && (msg.value > 1 ether)) || sender == 0x00) {
        sender = msg.sender;
        reciver = _reciver;
        unlockTime = now;
    }
}
