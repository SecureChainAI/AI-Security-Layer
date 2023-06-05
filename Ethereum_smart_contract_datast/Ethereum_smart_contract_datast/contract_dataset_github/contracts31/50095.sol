// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract AToken_test {
    mapping(address => uint256) balances;
    address UNDERLYING_ASSET_ADDRESS;

    constructor(address _stableToken) {
        UNDERLYING_ASSET_ADDRESS = _stableToken;
    }

    function balanceOf(address user) public view returns (uint256 balance) {
        return balances[user];
    }

    function mint(
        address user,
        uint256 amount,
        uint256 index
    ) external returns (bool) {
        index;
        uint256 previousBalance = balanceOf(user);
        _mint(user, amount);
        return previousBalance == 0;
    }

    function _mint(address user, uint256 amount) internal {
        balances[user] += amount;
    }

    function burn(
        address user,
        address receiverOfUnderlying,
        uint256 amount,
        uint256 index
    ) external {
        index;
        _burn(user, amount);
        IERC20(UNDERLYING_ASSET_ADDRESS).transfer(receiverOfUnderlying, amount);
    }

    function _burn(address user, uint256 amount) internal {
        balances[user] -= amount;
    }
}
