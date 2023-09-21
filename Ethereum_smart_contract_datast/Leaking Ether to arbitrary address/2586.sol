 public payable {
        if (responseHash == keccak256(guess) && msg.value>1 ether) {
            msg.sender.transfer(this.balance);
        }
    }
