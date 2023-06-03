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

import "./CustomOwnable.sol";


///@title This contract enables to create multiple contract administrators.
contract CustomAdmin is CustomOwnable {
  ///@notice List of administrators.
  mapping(address => bool) public admins;

  event AdminAdded(address indexed _address);
  event AdminRemoved(address indexed _address);

  ///@notice Validates if the sender is actually an administrator.
  modifier onlyAdmin() {
    require(isAdmin(msg.sender), "Access is denied.");
    _;
  }

  ///@notice Adds the specified address to the list of administrators.
  ///@param _address The address to add to the administrator list.
  function addAdmin(address _address) external onlyAdmin returns(bool) {
    require(_address != address(0), "Invalid address.");
    require(!admins[_address], "This address is already an administrator.");

    require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");

    admins[_address] = true;

    emit AdminAdded(_address);
    return true;
  }

  ///@notice Adds multiple addresses to the administrator list.
  ///@param _accounts The wallet addresses to add to the administrator list.
  function addManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
    for(uint8 i = 0; i < _accounts.length; i++) {
      address account = _accounts[i];

      ///Zero address cannot be an admin.
      ///The owner is already an admin and cannot be assigned.
      ///The address cannot be an existing admin.
      if(account != address(0) && !admins[account] && account != owner) {
        admins[account] = true;

        emit AdminAdded(_accounts[i]);
      }
    }

    return true;
  }

  ///@notice Removes the specified address from the list of administrators.
  ///@param _address The address to remove from the administrator list.
  function removeAdmin(address _address) external onlyAdmin returns(bool) {
    require(_address != address(0), "Invalid address.");
    require(admins[_address], "This address isn't an administrator.");

    //The owner cannot be removed as admin.
    require(_address != owner, "The owner cannot be added or removed to or from the administrator list.");

    admins[_address] = false;
    emit AdminRemoved(_address);
    return true;
  }

  ///@notice Removes multiple addresses to the administrator list.
  ///@param _accounts The wallet addresses to add to the administrator list.
  function removeManyAdmins(address[] _accounts) external onlyAdmin returns(bool) {
    for(uint8 i = 0; i < _accounts.length; i++) {
      address account = _accounts[i];

      ///Zero address can neither be added or removed from this list.
      ///The owner is the super admin and cannot be removed.
      ///The address must be an existing admin in order for it to be removed.
      if(account != address(0) && admins[account] && account != owner) {
        admins[account] = false;

        emit AdminRemoved(_accounts[i]);
      }
    }

    return true;
  }

  ///@notice Checks if an address is an administrator.
  function isAdmin(address _address) public view returns(bool) {
    if(_address == owner) {
      return true;
    }

    return admins[_address];
  }
}
