// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./IERC20.sol";
import "./SafeMath.sol";

contract DCACOIN is IERC20 {
    //Declare use of SafeMath library.
    using SafeMath for uint256;

    uint public constant _totalSupply = 1000000;
    //Balances of the accounts.
    mapping(address => uint256) balances;
    //First address is who is giving permission.
    //Second address correspond to who is being gived the permission and the amount to spend. 
    mapping(address => mapping(address => uint256)) allowed;

    string public constant symbol = "DCA";
    string public constant name = "DCA COIN";
    uint8 public constant decimals = 3;
    constructor () {
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external pure override returns (uint256){
        return _totalSupply;
    }
    
    function balanceOf(address account) external view override returns (uint256){
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool){
        require(balances[msg.sender] >= amount && amount > 0,"Insufficiente amount");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
        require(
            allowed[sender][msg.sender] >= amount
            && balances[sender] > amount
            && amount > 0 , "Your not allowed to spend from this account"
            );
        balances[sender] = balances[sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        allowed[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowed[owner][spender];
    }
}
