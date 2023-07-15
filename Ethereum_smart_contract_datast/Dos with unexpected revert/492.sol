function end(string _answer) public {
    require(msg.sender == riddler);
    answer = _answer;
    isActive = false;
    msg.sender.transfer(this.balance);
}
