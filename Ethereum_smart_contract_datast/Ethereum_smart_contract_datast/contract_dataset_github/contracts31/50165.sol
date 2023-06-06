/*
Copyright 2018 Binod Nirvan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http:///www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

pragma solidity ^0.4.24;

import "./CustomAdmin.sol";


///@title Custom Lockable Contract
///@author Binod Nirvan
///@notice This contract enables Cyber Security Ecosystem Token admins
///to lock tokens on an individual-wallet basis.
///When tokens are locked for specific wallet,
///they cannot transfer their balances
///until the end of their locking period.
///Furthermore, this feature is created to specifically
///lock bounty, advisory, and team tokens
///for a set period of time.
///This feature once turned off cannot be switched on back again.
contract CustomLockable is CustomAdmin {
  ///Locking list contains list of wallets and their respective release dates.
  mapping(address => uint256) public lockingList;

  ///Signifies if the locking feature can be used.
  bool public canLock = true;

  event TokenLocked(address indexed _address, uint256 _releaseDate);
  event TokenUnlocked(address indexed _address);
  event LockingDisabled();

  ///@notice Reverts this transfer if the wallet is in the locking list.
  modifier revertIfLocked(address _wallet) {
    require(!isLocked(_wallet), "The operation was cancelled because your tokens are locked.");
    _;
  }

  ///@notice Checks if a wallet is locked for transfers.
  function isLocked(address _wallet) public view returns(bool) {
    uint256 _lockedUntil = lockingList[_wallet];

    //solium-disable-next-line
    if(_lockedUntil > now) {
      return true;
    }

    return false;
  }

  ///@notice Adds the specified address to the locking list.
  ///@param _address The address to add to the locking list.
  ///@param _releaseDate The date when the tokens become avaiable for transfer.
  function addLock(address _address, uint256 _releaseDate) external onlyAdmin returns(bool) {
    require(canLock, "Access is denied. This feature was already disabled by an administrator.");
    require(_address != address(0), "Invalid address.");
    require(!admins[_address], "Cannot lock administrators.");
    require(_address != owner, "Cannot lock the owner.");

    lockingList[_address] = _releaseDate;

    if(_releaseDate > 0) {
      emit TokenLocked(_address, _releaseDate);
    } else {
      emit TokenUnlocked(_address);
    }

    return true;
  }

  ///@notice Adds multiple addresses to the locking list.
  ///@param _accounts The wallet addresses to add to the locking list.
  ///@param _releaseDate The date when the tokens become avaiable for transfer.
  function addManyLocks(address[] _accounts, uint256 _releaseDate) external onlyAdmin returns(bool) {
    require(canLock, "Access is denied. This feature was already disabled by an administrator.");
    require(_releaseDate > 0, "Invalid release date.");

    for(uint8 i = 0; i < _accounts.length; i++) {
      address _account = _accounts[i];

      ///Zero address, admins, and owner cannot be locked.
      if(_account != address(0) && !admins[_account] && _account != owner) {
        lockingList[_account] = _releaseDate;
        emit TokenLocked(_account, _releaseDate);
      }
    }

    return true;
  }

  ///@notice Removes multiple addresses from the locking list.
  ///@param _accounts The wallet addresses to unlock.
  function removeManyLocks(address[] _accounts) external onlyAdmin returns(bool) {
    require(canLock, "Access is denied. This feature was already disabled by an administrator.");

    for(uint8 i = 0; i < _accounts.length; i++) {
      address _account = _accounts[i];

      lockingList[_account] = 0;
      emit TokenUnlocked(_account);
    }

    return true;
  }

  ///@notice Once locking feature is disable, it cannot be
  ///truned back on thenceforth.
  function disableLocking() external onlyAdmin returns(bool) {
    require(canLock, "The token lock feature is already disabled.");

    canLock = false;
    emit LockingDisabled();
    return true;
  }
}