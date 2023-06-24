pragma solidity 0.6.12;

import "./Dependencies.sol";

contract InsecureEtherVault is ReentrancyGuard {
    mapping (address => uint256) private userBalances;

    function deposit() external payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external noReentrant {
        uint256 balance = getUserBalance(msg.sender);
        require(balance - _amount >= 0, "Insufficient balance");

        userBalances[msg.sender] -= _amount;
        
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}