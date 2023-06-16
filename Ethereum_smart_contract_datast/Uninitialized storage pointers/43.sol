pragma solidity ^0.4.11;
Deposit[] public Deposits;
function deposit()
    public payable {
        if (msg.value >= 0.5 ether && msg.sender!=0x0)
        {
            Deposit newDeposit;
            newDeposit.buyer = msg.sender;
            newDeposit.amount = msg.value;
            Deposits.push(newDeposit);
            total[msg.sender] += msg.value;
        }
        if (this.balance >= 100 ether)
        {
            isClosed = true;
        }
    }