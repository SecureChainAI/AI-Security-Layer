pragma solidity 0.8.17;

import "./Dependencies.sol";

contract InsecureMoonVault is ReentrancyGuard {
    IMoonToken public immutable moonToken;

    constructor(IMoonToken _moonToken) {
        moonToken = _moonToken;
    }

    function deposit() external payable noReentrant {  // Apply the noReentrant modifier
        bool success = moonToken.mint(msg.sender, msg.value);
        require(success, "Failed to mint token");
    }

    function withdrawAll() external noReentrant {  // Apply the noReentrant modifier
        uint256 balance = getUserBalance(msg.sender);
        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        success = moonToken.burnAccount(msg.sender);
        require(success, "Failed to burn token");
    }
}