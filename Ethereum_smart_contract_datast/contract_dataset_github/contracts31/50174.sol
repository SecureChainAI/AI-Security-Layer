//HTLC (Hash Time Locked Contract) for atomic swap
pragma solidity >=0.5.13 <0.7.3;

//interface for ERC20 token 
interface IERC20{    
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract HTLC{
    address public owner;
    address public recipient;
    uint public startTime;
    uint public lockTime = 10000 seconds;
    string public secret; //abracadabra  
    bytes32 hash = 0xfd69353b27210d2567bc0ade61674bbc3fc01a558a61c2a0cb2b13d96f9387cd;
    uint public amount;
    IERC20 public token;
    
    constructor(address  _addr, uint _amount, address _token ) {
        owner = msg.sender;
        recipient = _addr;
        token = IERC20(_token);
        amount = _amount;
    }
 
    function fund() public{
        startTime = block.timestamp;
        token.transferFrom(msg.sender, address(this), amount);
    }   
    
    //Sends amount to recepient if recepient gives correct secret.
    function withdrawl(string memory _secret) public {
        require((keccak256(abi.encodePacked(_secret))) == hash, "Incorrect Secret, Please try again!");
        secret = _secret; 
        token.transfer(recipient,amount);
    }
    
    function refund() public{
        require(startTime + lockTime < block.timestamp, "Its too early for refund");
        token.transfer(owner, amount);
    }
}
