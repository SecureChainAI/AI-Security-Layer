function Sort() internal {
    uint feecounter;
    feecounter += msg.value / 5;
    owner.send(feecounter);

    feecounter = 0;
    uint txcounter = Tx.length;
    counter = Tx.length;
    Tx.length++;
    Tx[txcounter].txuser = msg.sender;
    Tx[txcounter].txvalue = msg.value;
}
