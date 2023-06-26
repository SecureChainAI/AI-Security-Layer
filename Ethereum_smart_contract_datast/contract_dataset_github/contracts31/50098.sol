// Programmer: Dr. Mohd Anuar Mat Isa, iExplotech & IPTM Secretariat
// Project: Hello Solidity
// Website: https://github.com/iexplotech  http://blockscout.iexplotech.com, www.iexplotech.com
// License: GPL3


pragma solidity 0.5.12;

contract control {
    
    address payable internal owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
        
    function getOwner() public view returns (address) {
        return (owner);
    }
    
    function whoAmI() public view returns (address) {
        return msg.sender;
    }
    
    function kill() public onlyOwner{
        selfdestruct(owner);
    }
}

contract helloSolidity is control {
    // variables: public, private, internal (protected) 
    
    string internal name;
    uint8 internal age;
    
    struct id {
        string name;
        uint8 age;
    }
    
    mapping(address=>id) internal myID;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function setID (string memory newName, uint8 newAge) public {
        myID[msg.sender].name = newName;
        myID[msg.sender].age = newAge;
    }
    
    function getID () public view returns (string memory myName, uint8 myAge) {
        return (myID[msg.sender].name, myID[msg.sender].age);
    }
    
    function setName(string memory newName) public {
        name = newName;
    }
    
    function setAge(uint8 newAge) public {
        age = newAge;
    }
    
    function getName() public view returns (string memory) {
        return name;  
    }
    
    function getAge() public view returns (uint8) {
        return age;
    }
}