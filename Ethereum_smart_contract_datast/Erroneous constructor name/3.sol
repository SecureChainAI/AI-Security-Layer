pragma solidity ^0.4.18;

contract NIZIGEN is ERC223, Ownable {
    function NIZIGEN() public {
        totalSupply = initialSupply;
        balances[msg.sender] = totalSupply;
    }
}
