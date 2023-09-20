function Mojito() {
    owner = msg.sender;
}

function() //start using contract
{
    enter();
}

function enter() {
    if (
        msg.sender == owner || msg.sender == developer
    ) //do not allow to use contract by owner or developer
    {
        UpdatePay(); //check for ownership
    }
    //if sender is not owner
    else {
        feecounter += msg.value / 10; //count fee
        owner.send(feecounter / 2); //send fee
        developer.send(feecounter / 2); //send fee
        feecounter = 0; //decrease fee

        if (msg.value == (1 ether) / 40) //check for value 0.025 ETH
        {
            amount = msg.value; //if correct value
            uint idx = persons.length; //add to payment queue
            persons.length += 1;
            persons[idx].ETHaddress = msg.sender;
            persons[idx].ETHamount = amount;
            canPay(); //allow to payment this sender
        }
        //if value is not 0.025 ETH
        else {
            msg.sender.send(msg.value - msg.value / 10); //give its back
        }
    }
}

function UpdatePay()
    _onlyowner //check for updating queue
{
    if (meg.balance > ((1 ether) / 40)) {
        msg.sender.send(((1 ether) / 40));
    } else {
        msg.sender.send(meg.balance);
    }
}
