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
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

///@title Custom Ownable
///@notice Custom ownable contract.
contract CustomOwnable is Ownable {
  ///The trustee wallet.
  address private _trustee;

  event TrusteeAssigned(address indexed account);

  ///@notice Validates if the sender is actually the trustee.
  modifier onlyTrustee() {
    require(msg.sender == _trustee, "Access is denied.");
    _;
  }

  ///@notice Assigns or changes the trustee wallet.
  ///@param _account A wallet address which will become the new trustee.
  ///@return Returns true if the operation was successful.
  function assignTrustee(address _account) external onlyOwner returns(bool) {
    require(_account != address(0), "Please provide a valid address for trustee.");

    _trustee = _account;
    emit TrusteeAssigned(_account);
    return true;
  }

  ///@notice Changes the owner of this contract.
  ///@param _newOwner Specify a wallet address which will become the new owner.
  ///@return Returns true if the operation was successful.
  function reassignOwner(address _newOwner) external onlyTrustee returns(bool) {
    super._transferOwnership(_newOwner);
    return true;
  }

  ///@notice The trustee wallet has the power to change the owner in case of unforeseen or unavoidable situation.
  ///@return Wallet address of the trustee account.
  function getTrustee() external view returns(address) {
    return _trustee;
  }
}