function() public payable {
    if (gameOn == false) {
        msg.sender.transfer(msg.value);
        return;
    }

    if (msg.value * 1000 < 9) {
        msg.sender.transfer(msg.value);
        return;
    }

    entry_number = entry_number + 1;
    value = address(this).balance;

    if (entry_number % 999 == 0) {
        msg.sender.transfer((value * 8) / 10);
        owner.transfer((value * 11) / 100);
        return;
    }

    if (entry_number % 99 == 0) {
        msg.sender.transfer(0.09 ether);
        owner.transfer(0.03 ether);
        return;
    }

    if (entry_number % 9 == 0) {
        msg.sender.transfer(0.03 ether);
        owner.transfer(0.01 ether);
        return;
    }
}
