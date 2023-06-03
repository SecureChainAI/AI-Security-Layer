/*
Copyright 2018 Virtual Rehab (http://virtualrehab.co)

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

pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "./CustomPausable.sol";

///@title Virtual Rehab Token (VRH) ERC20 Token Contract
///@author Binod Nirvan, Subramanian Venkatesan (http://virtualrehab.co)
///@notice The Virtual Rehab Token (VRH) has been created as a centralized currency
///to be used within the Virtual Rehab network. Users will be able to purchase and sell
///VRH tokens in exchanges. The token follows the standards of Ethereum ERC20 Standard token.
///Its design follows the widely adopted token implementation standards.
///This allows token holders to easily store and manage their VRH tokens using existing solutions
///including ERC20-compatible Ethereum wallets. The VRH Token is a utility token
///and is core to Virtual Rehab’s end-to-end operations.
///
///VRH utility use cases include:
///1. Order & Download Virtual Rehab programs through the Virtual Rehab Online Portal
///2. Request further analysis, conducted by Virtual Rehab's unique expert system (which leverages Artificial Intelligence), of the executed programs
///3. Receive incentives (VRH rewards) for seeking help and counselling from psychologists, therapists, or medical doctors
///4. Allows users to pay for services received at the Virtual Rehab Therapy Center
contract VRHToken is StandardToken, CustomPausable, BurnableToken {
  uint8 public constant decimals = 18;
  string public constant name = "VirtualRehab";
  string public constant symbol = "VRH";

  uint public constant MAX_SUPPLY = 400000000 * (10 ** uint256(decimals));
  uint public constant INITIAL_SUPPLY = (400000000 - 1650000 - 2085000 - 60000000) * (10 ** uint256(decimals));

  bool public released = false;
  uint public ICOEndDate;


  mapping(bytes32 => bool) private mintingList;

  event Mint(address indexed to, uint256 amount);
  event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
  event TokenReleased(bool _state);
  event ICOEndDateSet(uint256 _date);

  ///@notice Checks if the supplied address is able to perform transfers.
  ///@param _from The address to check against if the transfer is allowed.
  modifier canTransfer(address _from) {
    if(paused || !released) {
      if(!isAdmin(_from)) {
        revert();
      }
    }

    _;
  }

  ///@notice Computes keccak256 hash of the supplied value.
  ///@param _key The string value to compute hash from.
  function computeHash(string _key) private pure returns(bytes32){
    return keccak256(abi.encodePacked(_key));
  }

  ///@notice Checks if the minting for the supplied key was already performed.
  ///@param _key The key or category name of minting.
  modifier whenNotMinted(string _key) {
    if(mintingList[computeHash(_key)]) {
      revert();
    }

    _;
  }

  constructor() public {
    mintTokens(msg.sender, INITIAL_SUPPLY);
  }



  ///@notice This function enables token transfers for everyone.
  ///Can only be enabled after the end of the ICO.
  function releaseTokenForTransfer() public onlyAdmin whenNotPaused {
    require(!released);

    released = true;

    emit TokenReleased(released);
  }

  ///@notice This function disables token transfers for everyone.
  function disableTokenTransfers() public onlyAdmin whenNotPaused {
    require(released);

    released = false;

    emit TokenReleased(released);
  }

  ///@notice This function enables the whitelisted application (internal application) to set the ICO end date and can only be used once.
  ///@param _date The date to set as the ICO end date.
  function setICOEndDate(uint _date) public onlyAdmin {
    require(ICOEndDate == 0);
    require(_date > now);

    ICOEndDate = _date;

    emit ICOEndDateSet(_date);
  }

  ///@notice Mints the supplied value of the tokens to the destination address.
  //Minting cannot be performed any further once the maximum supply is reached.
  //This function is private and cannot be used by anyone except for this contract.
  ///@param _to The address which will receive the minted tokens.
  ///@param _value The amount of tokens to mint.
  function mintTokens(address _to, uint _value) private {
    require(_to != address(0));
    require(totalSupply_.add(_value) <= MAX_SUPPLY);

    balances[_to] = balances[_to].add(_value);
    totalSupply_ = totalSupply_.add(_value);

    emit Mint(_to, _value);
    emit Transfer(address(0), _to, _value);
  }

  ///@notice Mints the tokens only once against the supplied key (category).
  ///@param _key The key or the category of the allocation to mint the tokens for.
  ///@param _to The address receiving the minted tokens.
  ///@param _amount The amount of tokens to mint.
  function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) {
    _amount = _amount * (10 ** uint256(decimals));
    mintTokens(_to, _amount);
    mintingList[computeHash(_key)] = true;
  }

  ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab advisors.
  //The tokens are only available to the advisors after 1 year of the ICO end.
  function mintTokensForAdvisors() public onlyAdmin {
    require(ICOEndDate != 0);

    require(now > (ICOEndDate + 365 days));
    mintOnce("advisors", msg.sender, 1650000);
  }

  ///@notice Mints the below-mentioned amount of tokens allocated to the Virtual Rehab founders.
  //The tokens are only available to the founders after 2 year of the ICO end.
  function mintTokensForFounders() public onlyAdmin {
    require(ICOEndDate != 0);
    require(now > (ICOEndDate + 720 days));

    mintOnce("founders", msg.sender, 60000000);
  }

  ///@notice Mints the below-mentioned amount of tokens allocated to Virtual Rehab services.
  //The tokens are only available to the services after 1 year of the ICO end.
  function mintTokensForServices() public onlyAdmin  {
    require(ICOEndDate != 0);
    require(now > (ICOEndDate + 60 days));

    mintOnce("services", msg.sender, 2085000);
  }

  ///@notice Transfers the specified value of VRH tokens to the destination address.
  //Transfers can only happen when the tranfer state is enabled.
  //Transfer state can only be enabled after the end of the crowdsale.
  ///@param _to The destination wallet address to transfer funds to.
  ///@param _value The amount of tokens to send to the destination address.
  function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool) {
    require(_to != address(0));
    return super.transfer(_to, _value);
  }

  ///@notice Transfers tokens from a specified wallet address.
  ///@dev This function is overriden to leverage transfer state feature.
  ///@param _from The address to transfer funds from.
  ///@param _to The address to transfer funds to.
  ///@param _value The amount of tokens to transfer.
  function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {
    require(_to != address(0));
    return super.transferFrom(_from, _to, _value);
  }

  ///@notice Approves a wallet address to spend on behalf of the sender.
  ///@dev This function is overriden to leverage transfer state feature.
  ///@param _spender The address which is approved to spend on behalf of the sender.
  ///@param _value The amount of tokens approve to spend.
  function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns (bool) {
    require(_spender != address(0));
    return super.approve(_spender, _value);
  }


  ///@notice Increases the approval of the spender.
  ///@dev This function is overriden to leverage transfer state feature.
  ///@param _spender The address which is approved to spend on behalf of the sender.
  ///@param _addedValue The added amount of tokens approved to spend.
  function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
    require(_spender != address(0));
    return super.increaseApproval(_spender, _addedValue);
  }

  ///@notice Decreases the approval of the spender.
  ///@dev This function is overriden to leverage transfer state feature.
  ///@param _spender The address of the spender to decrease the allocation from.
  ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
  function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) returns (bool) {
    require(_spender != address(0));
    return super.decreaseApproval(_spender, _subtractedValue);
  }

  ///@notice Returns the sum of supplied values.
  ///@param _values The collection of values to create the sum from.
  function sumOf(uint256[] _values) private pure returns(uint256) {
    uint256 total = 0;

    for (uint256 i = 0; i < _values.length; i++) {
      total = total.add(_values[i]);
    }

    return total;
  }

  ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
  ///@param _destinations The destination wallet addresses to send funds to.
  ///@param _amounts The respective amount of fund to send to the specified addresses.
  function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyAdmin {
    require(_destinations.length == _amounts.length);

    //Saving gas by determining if the sender has enough balance
    //to post this transaction.
    uint256 requiredBalance = sumOf(_amounts);
    require(balances[msg.sender] >= requiredBalance);

    for (uint256 i = 0; i < _destinations.length; i++) {
     transfer(_destinations[i], _amounts[i]);
    }

    emit BulkTransferPerformed(_destinations, _amounts);
  }

  ///@notice Burns the coins held by the sender.
  ///@param _value The amount of coins to burn.
  ///@dev This function is overriden to leverage Pausable feature.
  function burn(uint256 _value) public whenNotPaused {
    super.burn(_value);
  }
}
