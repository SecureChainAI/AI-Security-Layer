pragma solidity >= 0.5.13 < 0.7.3;

contract wallet{
    
    
    address admin;
    uint public balance;// Total balance of contract
    
    
    struct employee{
        string name;
        uint password; //transaction password like UPI password. 
        string dept;  //Department of employee.
        string job_code; //Job Code of employee.
        uint emp_balance; //wallet balance of employee.
        uint credited;   //Amount credited by finance employee in wallet.
    }
    
    mapping(address => employee) public  info;
    
    //initialize admin
    constructor() public{
        admin= msg.sender;
    }
    
    //user registration function
    function registerUser(string memory u_name, uint u_password, string memory u_dept, string memory u_job_code ) public{
        info[msg.sender].name= u_name;
        info[msg.sender].password= u_password;
        info[msg.sender].dept= u_dept;
        info[msg.sender].job_code= u_job_code;
        info[msg.sender].emp_balance ; 
    }
    
    //below function recieves ether in contract only by Finance employee i.e employees having job_code = "F1"
    function recieveEther(uint u_password) public  payable {
        require(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("F1")), "Restricted Entry");
        balance += msg.value; 
        info[msg.sender].credited += msg.value;
    }
    
    //below function transfer ether from contract to employee,where transaction amount is limited according to employee grade/job_code.
    //job_code= "1A","1B","1C" => has limit of 30 ethers.
    //job_code= "2A","2B","2C" => has limit of 20 ethers.
    //job_code= "3A","3B","3C" => has limit of 10 ethers.
    //job_code= "4A","4B","4C" => has limit of 5 ethers.
    //job_code= "5A","5B","5C" => has limit of 2 ethers.
    //job_code= "F1" has no limit on transaction amount.
    function debitEther( uint amount, uint u_password) public { 
        require(info[msg.sender].password== u_password ,"Unauthorized Login");
        require(keccak256(abi.encodePacked(info[msg.sender].job_code)) != keccak256(abi.encodePacked("")), "No details found.Please Register");
        
        if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("1A")) ||
           keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("1B"))||
           keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("1C"))) {
               require(amount <= balance, "Insufficient balance , Contact admin");
               require(amount <= 30 ether,"Your Debit limit is 30 Ether!");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
           }
        else if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("2A")) ||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("2B"))||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("2C"))) {
               require(amount <= balance, "Insufficient balance , Contact admin");
               require(amount <= 20 ether,"Your Debit limit is 20 Ether!");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
           }
        else if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("3A")) ||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("3B"))||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("3C"))) {
               require(amount <= balance, "Insufficient balance , Contact admin");
               require(amount <= 10 ether,"Your Debit limit is 10 Ether!");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
           }
        else if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("4A")) ||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("4B"))||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("4C"))) {
               require(amount <= balance, "Insufficient balance , Contact admin");
               require(amount <= 5 ether,"Your Debit limit is 5 Ether!");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
           }
        else if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("5A")) ||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("5B"))||
                keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("5C"))) {
               require(amount <= balance, "Insufficient balance , Contact admin");
               require(amount <= 2 ether,"Your Debit limit is 2 Ether!");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
           }
        else if(keccak256(abi.encodePacked(info[msg.sender].job_code)) == keccak256(abi.encodePacked("F1"))){
               require(amount <= balance, "Insufficient balance , Contact admin");
               address payable _to = msg.sender;
               _to.transfer(amount);
               info[msg.sender].emp_balance += amount;
               balance -= amount; 
        }
         
    }
    
    //below function changes transaction password
    function changePassword(uint u_password, uint u_new_password)public{
          require(info[msg.sender].password== u_password ,"Unauthorized Login");
          info[msg.sender].password = u_new_password;
    }
    
    
}
