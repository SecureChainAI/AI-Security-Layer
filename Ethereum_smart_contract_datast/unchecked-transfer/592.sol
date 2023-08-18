        havven.transfer(havven, quantity);
            havven.transfer(msg.sender, total);
        nomin.transfer(msg.sender, requestedToPurchase);
        havven.transfer(msg.sender, havvensToSend);
        nomin.transferFrom(msg.sender, this, nominAmount);
        havven.transfer(msg.sender, havvensToSend);
        havven.transfer(owner, amount);
        nomin.transfer(owner, amount);
