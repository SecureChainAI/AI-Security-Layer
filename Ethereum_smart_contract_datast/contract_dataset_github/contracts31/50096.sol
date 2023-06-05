// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import './ERC20Permit.sol';

contract ERC20_test is ERC20Permit {
    constructor(uint256 initialSupply) ERC20Permit('ERC20Token') {
        _mint(msg.sender, initialSupply);
    }

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
