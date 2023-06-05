/*
Copyright 2018 Binod Nirvan
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "./CustomAdmin.sol";


///@title Reclaimable Contract
///@author Binod Nirvan
///@notice Reclaimable contract enables the administrators
///to reclaim accidentally sent Ethers and ERC20 token(s)
///to this contract.
contract Reclaimable is CustomAdmin {
  using SafeERC20 for ERC20;

  ///@notice Transfers all Ether held by the contract to the owner.
  function reclaimEther() external onlyAdmin {
    msg.sender.transfer(address(this).balance);
  }

  ///@notice Transfers all ERC20 tokens held by the contract to the owner.
  ///@param _token The amount of token to reclaim.
  function reclaimToken(address _token) external onlyAdmin {
    ERC20 erc20 = ERC20(_token);
    uint256 balance = erc20.balanceOf(this);
    erc20.safeTransfer(msg.sender, balance);
  }
}