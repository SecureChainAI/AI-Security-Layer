pragma solidity >= 0.5.13 < 0.7.3;

contract bank{
    address public owner;
    
    struct userAccount{
        uint256 amount;
        string user_name;
    }
    
    mapping(address => userAccount) public userLedger;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function addEther(string memory _name) public payable{
        userLedger[msg.sender].user_name = _name;
        userLedger[msg.sender].amount =  userLedger[msg.sender].amount + msg.value;
    }
    
    function withdrawEther(address payable _to, uint256 _wamount) public{
        require(userLedger[_to].amount >= _wamount, "You have insufficient balance in your account");
        _to.transfer(_wamount);
        userLedger[_to].amount = userLedger[_to].amount - _wamount;
        
    }
    
    function accountBalance()public view returns(uint256){
        return userLedger[msg.sender].amount;
    }
}
