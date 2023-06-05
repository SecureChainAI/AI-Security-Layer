//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.8.0;

contract StoreConcert {
    address owner;
    uint public tickets;
    uint constant price = 1 ether;
    mapping (address => uint) public purchasers;
    
    constructor(uint amount) public {
        owner = msg.sender;
        tickets  = 5;
        amount = amount;
    }
    //Generate a nonnamed function that by 1  ticket;
    function () public payable {
        byTickets(1);
    }
    
    function byTickets(uint amount) public payable{
        require(msg.value == (amount * price) && amount <= tickets,
        "Send the right value by this amount of tickets");
        
        purchasers[msg.sender] += amount;
        tickets -= amount;
        if (tickets == 0){
            selfdestruct(owner);
        }
    }
    
    //Function that  need to be implemented by the MetallicaConcert;
    function website() public returns (string);

}

interface Redundable {
    //This interface has an abstract method that need to be implemented to refun the values of purchasers.
    function refund(uint tickets) external returns(bool);
}

//This sintax is like: (MetallicaConcert extend StoreConcert implement Redundable)
contract MetallicaConcert is StoreConcert(1000),  Redundable {
    function website() public returns(string) {
        return "https://mettallica.store.com/concert1";
    }
    
    function refund(uint nTickets) public returns(bool){
        if(purchasers[msg.sender] < nTickets){
            return false;
        }
        purchasers[msg.sender] -= nTickets;
        msg.sender.transfer(nTickets * price);
        tickets +=nTickets;
        return true;
    }
}
