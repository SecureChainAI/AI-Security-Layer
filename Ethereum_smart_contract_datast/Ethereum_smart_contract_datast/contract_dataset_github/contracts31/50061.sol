// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './IAToken.sol';

contract LendingPool_test {
    address aToken;

    constructor(address _aToken) {
        aToken = _aToken;
    }

    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external {
        referralCode;
        IERC20(asset).transferFrom(msg.sender, aToken, amount);
        IAToken(aToken).mint(onBehalfOf, amount, 0);
    }

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256) {
        asset;
        uint256 userBalance = IAToken(aToken).balanceOf(msg.sender);
        uint256 amountToWithdraw = amount;
        if (amount == type(uint256).max) {
            amountToWithdraw = userBalance;
        }
        IAToken(aToken).burn(msg.sender, to, amountToWithdraw, 0);

        return amountToWithdraw;
    }
}
