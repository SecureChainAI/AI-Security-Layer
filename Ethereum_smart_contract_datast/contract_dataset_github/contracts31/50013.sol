// Programmer: Dr. Mohd Anuar Mat Isa, iExplotech & IPTM Secretariat
// Project: Simple Personal DB
// Website: https://github.com/iexplotech  www.iptm.online, www.iexplotech.com
// License: GPL3

pragma solidity ^0.5.12;

contract myLib {
    
    address payable internal owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function whoAmI () public view returns (address) {
        return msg.sender;
    }
    
    function getOwner () public view returns (address) {
        return owner;
    }
    
    function kill() public onlyOwner {
            selfdestruct(owner);
    }
}

contract myPersonal is myLib {

    struct myDatabase {
        string name;
        uint256 age;
        string email;
    }
    
    myDatabase internal myDB;
    mapping (address=>myDatabase) internal myMapDB;
    
    constructor () public {
        owner = msg.sender;
    }
    // everyone may change value
    function setSharedDB (string memory newName, uint256 newAge, string memory newEmail) public {
        myDB.name = newName;
        myDB.age = newAge;
        myDB.email = newEmail;
    }
    
    function getSharedDB () public view returns (string memory, uint256, string memory) {
        return (myDB.name, myDB.age, myDB.email);
    }
    
    // only contract owner can execute
    function setAnyMapDB (address newAddress, string memory newName, uint256 newAge, string memory newEmail) public onlyOwner {
        myMapDB[newAddress].name = newName;
        myMapDB[newAddress].age = newAge;
        myMapDB[newAddress].email = newEmail;
    }
    
    function getAnyMapDB (address newAddress) public view onlyOwner returns (string memory, uint256, string memory) {
        return (myMapDB[newAddress].name, myMapDB[newAddress].age, myMapDB[newAddress].email);
    }
    
    // only account owner can execute
    function setMyMapDB (string memory newName, uint256 newAge, string memory newEmail) public {
        myMapDB[msg.sender].name = newName;
        myMapDB[msg.sender].age = newAge;
        myMapDB[msg.sender].email = newEmail;
    }
    
    function getMyMapDB () public view returns (string memory, uint256, string memory) {
        return (myMapDB[msg.sender].name, myMapDB[msg.sender].age, myMapDB[msg.sender].email);
    }
}


