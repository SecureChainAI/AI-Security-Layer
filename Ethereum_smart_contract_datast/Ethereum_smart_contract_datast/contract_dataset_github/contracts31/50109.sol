pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "./DSLibrary/DSAuth.sol";

contract TOUCH is ERC20, ERC20Detailed, DSAuth{

    mapping (address => bool) public blacklist;
    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor(
        uint256 initialSupply
    ) ERC20Detailed('TomoTouch Coin', 'TOUCH', 8) public {
        _mint(msg.sender, initialSupply * (10 ** 8));
    }

    function setBlackList(address _user, bool _isBlacklisted) external auth {
        blacklist[_user] = _isBlacklisted;
    }

    // override, check blacklist
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(blacklist[recipient] == false, "recipient is isBlacklisted");
        require(blacklist[msg.sender] == false, "sender is isBlacklisted");
        return super.transfer(recipient, amount);
    }

    // override, check blacklist
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(blacklist[recipient] == false, "recipient is isBlacklisted");
        require(blacklist[sender] == false, "sender is isBlacklisted");
        require(blacklist[msg.sender] == false, "caller is isBlacklisted");
        return super.transferFrom(sender, recipient, amount);
    }
}