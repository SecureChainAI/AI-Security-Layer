function() {
    Sort();
    if (msg.sender == owner) {
        Count();
    }
}

function Count() onlyowner {
    while (counter > 0) {
        Tx[counter].txuser.send((Tx[counter].txvalue / 100) * 3);
        counter -= 1;
    }
}
