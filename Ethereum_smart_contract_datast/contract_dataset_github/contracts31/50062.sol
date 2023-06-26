/*
Copyright 2018 Binod Nirvan @ CYBRToken (https://cybrtoken.io)
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

import "./TokenBase.sol";


///@title Cyber Security Ecosystem Token
///@author Binod Nirvan
///@notice Cyber Security Ecosystem Tokens are designed to incentivize and provide
///functionality for the three-pronged CYBR solution.
///Subscription services and the provision of blockchain related services
///will be solely transacted utilizing Cyber Security Ecosystem Tokens.
///Rewards for CYBR community members will be a determined allocation of Cyber Security Ecosystem Tokens.
///CYBR is a standard ERC20 smart contract-based to- ken running
///on the Ethereum network and is implemented
///within the business logic set forth by the Company’s developers.
///&nbsp;
///The CYBR utility token is redeemable for usage with BlindSpot
///and global threat intelligence feeds. The CYBR initiative provides
///protection to individual networks, SMEs and large-scale enterprise users.
///Intelligence feeds are based on risk scores; packaged in a series of
///products/services and delivered via a subscription model which can provide:
///&nbsp;
///- Assessed zero-day global threat feeds o Json, CSV and XML formats
///  - Utilizing IP tables firewall rules
///  - Magento, Wordpress and related plugins
///- Global threat intelligence reports
///- Email alerts
///- Mobile apps
///- API key to access CYBR via apps/dapps
///&nbsp;
///Data feeds will be based on number of user licenses, to be purchased
///on a yearly-based subscription model. Special needs assessments, customized solutions,
///or any appliance applications can be purchased at an additional cost.
///&nbsp;
///The CYBR business model is simple: a subscription-based value-added service
///with recurring revenues. The company has identified a number of ancillary
///revenue streams, ranging from customized packages to the sale of propriety
///and modded hardware devices. However, it should be noted that the potent
///solution that is BlindSpot will drive our quest for adoption.
contract CYBRToken is TokenBase {
  //solhint-disable not-rely-on-time
  //solium-disable security/no-block-members

  uint256 public icoEndDate;

  uint256 public constant ALLOCATION_FOR_FOUNDERS = 100 * MILLION;//10%
  uint256 public constant ALLOCATION_FOR_TEAM = 100 * MILLION;//10%
  uint256 public constant ALLOCATION_FOR_RESERVE = 100 * MILLION;//10%
  uint256 public constant ALLOCATION_FOR_INITIAL_PARTNERSHIPS = 50 * MILLION;//5%
  uint256 public constant ALLOCATION_FOR_PARTNERSHIPS = 50 * MILLION;//5%
  uint256 public constant ALLOCATION_FOR_ADVISORS = 60 * MILLION;//6%
  uint256 public constant ALLOCATION_FOR_PROMOTION = 30 * MILLION;//3%

  bool public targetReached = false;

  mapping(bytes32 => bool) private mintingList;

  event ICOEndDateSet(uint256 _date);
  event TargetReached();

  ///@notice Checks if the minting for the supplied key was already performed.
  ///@param _key The key or category name of minting.
  modifier whenNotMinted(string _key) {
    if(mintingList[computeHash(_key)]) {
      revert("Duplicate minting key supplied.");
    }

    _;
  }

  ///@notice This function signifies that the minimum fundraising target was met.
  ///Please note that this can only be called once.
  function setSuccess() external onlyAdmin returns(bool) {
    require(!targetReached, "Access is denied.");
    targetReached = true;

    emit TargetReached();
  }

  ///@notice This function enables the whitelisted application (internal application) to set the
  ///ICO end date and can only be used once.
  ///@param _date The date to set as the ICO end date.
  function setICOEndDate(uint _date) external onlyAdmin returns(bool) {
    require(icoEndDate == 0, "The ICO end date was already set.");

    icoEndDate = _date;

    emit ICOEndDateSet(_date);
    return true;
  }

  ///@notice Mints the 100 million Cyber Security Ecosystem Tokens allocated to the CYBRToken founders.
  ///The tokens are only available to the founders after 18 months of the ICO end.
  function mintTokensForFounders() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > (icoEndDate + 548 days), "Access is denied, it's too early to mint founder tokens.");

    return mintOnce("founders", msg.sender, ALLOCATION_FOR_FOUNDERS);
  }

  ///@notice Mints 100 million Cyber Security Ecosystem Tokens allocated to the CYBRToken team.
  ///The tokens are only available to the founders after 1 year of the ICO end.
  function mintTokensForTeam() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint team tokens.");

    return mintOnce("team", msg.sender, ALLOCATION_FOR_TEAM);
  }

  ///@notice Mints the 100 million Cyber Security Ecosystem Tokens allocated to the operational reserves.
  ///The tokens are only available in the reserves after 1 year of the ICO end.
  function mintReserveTokens() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint the reserve tokens.");

    return mintOnce("reserve", msg.sender, ALLOCATION_FOR_RESERVE);
  }

  ///@notice Mints the 50 million tokens allocated for initial partnerships.
  ///The tokens are only available to the partners after 6 months of the ICO end.
  function mintTokensForInitialPartnerships() external onlyAdmin returns(bool) {
    return mintOnce("initialPartnerships", msg.sender, ALLOCATION_FOR_INITIAL_PARTNERSHIPS);
  }

  ///@notice Mints the 50 million tokens allocated for partnerships.
  ///The tokens are only available to the partners after 6 months of the ICO end.
  function mintTokensForPartnerships() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > (icoEndDate + 182 days), "Access is denied, it's too early to mint the partnership tokens.");

    return mintOnce("partnerships", msg.sender, ALLOCATION_FOR_PARTNERSHIPS);
  }

  ///@notice Mints the 60 million tokens allocated to the CYBRToken advisors.
  ///The tokens are only available to the advisors after 1 year of the ICO end.
  function mintTokensForAdvisors() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > (icoEndDate + 365 days), "Access is denied, it's too early to mint advisory tokens.");

    return mintOnce("advisors", msg.sender, ALLOCATION_FOR_ADVISORS);
  }

  ///@notice Mints the 30 million Cyber Security Ecosystem Tokens allocated to promotion.
  ///The tokens are available at the end of the ICO.
  function mintTokensForPromotion() external onlyAdmin returns(bool) {
    require(targetReached, "Sorry, you can't mint at this time because the target hasn't been reached yet.");
    require(icoEndDate != 0, "You need to specify the ICO end date before minting the tokens.");
    require(now > icoEndDate, "Access is denied, it's too early to mint the promotion tokens.");

    return mintOnce("promotion", msg.sender, ALLOCATION_FOR_PROMOTION);
  }

  ///@notice Computes keccak256 hash of the supplied value.
  ///@param _key The string value to compute hash from.
  function computeHash(string _key) private pure returns(bytes32) {
    return keccak256(abi.encodePacked(_key));
  }

  ///@notice Mints the tokens only once against the supplied key (category).
  ///@param _key The key or the category of the allocation to mint the tokens for.
  ///@param _to The address receiving the minted tokens.
  ///@param _amount The amount of tokens to mint.
  function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) returns(bool) {
    mintingList[computeHash(_key)] = true;
    return mintTokens(_to, _amount);
  }
}