function Divsforall() public payable {
    require(divsforall = true);
    require(msg.value >= 1 finney);
    div = harvestabledivs();
    require(div > 0);
    claimdivs();
    msg.sender.transfer(div);
    emit onHarvest(msg.sender, div);
}
