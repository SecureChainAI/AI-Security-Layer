// SPDX-License-Identifier: UNLICENSED
/**
*
* 
* 
    ███████╗████████╗██╗  ██╗    ██████╗  ██████╗ ██╗     ██╗     
    ██╔════╝╚══██╔══╝██║  ██║    ██╔══██╗██╔═══██╗██║     ██║     
    █████╗     ██║   ███████║    ██████╔╝██║   ██║██║     ██║     
    ██╔══╝     ██║   ██╔══██║    ██╔══██╗██║   ██║██║     ██║     
    ███████╗   ██║   ██║  ██║    ██║  ██║╚██████╔╝███████╗███████╗
    ╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
*
*
*
**/

pragma solidity ^0.7.4;

// import "./libs/access/Roles.sol";

import "./Ownable.sol";
import "./ERC20.sol";
import "./api.sol";
// import "./SafeMath.sol";

contract ETRToken is ERC20, Ownable {
     using SafeMath for uint256;
     
    // using Roles for Roles.Role;

    // Roles.Role private _airdrops;

    uint256 private _birthDay;

    uint256 public constant INVEST_MIN_AMOUNT = 0.01 ether;
    uint256 public constant ETRRATE = 200000 * 10 ** 8;
    uint256 public constant SOFT_CAP = 250 ether;

    enum StatusType {Ready, Started, Ended, Success, Failed, RefundedAll}

    StatusType status = StatusType.Ready;

    uint32 public startDate = 0;
    uint32 public endDate = 0;

    uint256 public totalInvested = 0;

    struct User {
        uint256 id;
        address referrer;
        uint256 ethAmount;
        uint256 ethRefunded;    //To validate if ether was refunded correctly.
    }

    mapping(address => User) users;
    mapping(uint256 => address) userIds;
    uint256 lastUserId = 0;
        
    event EventStatus(string message);

    constructor(uint256 initialSupply, address team)
        ERC20("ETH Roll", "ETR", 8)
    {
        require(
            !isContract(msg.sender) && !isContract(team),
            "Owner and team cannot be a contract"
        );

        require(
            msg.sender != team,
            "The team address must be different from the Owner's address."
        );

        _mint(msg.sender, initialSupply.div(2));    //hard cap(50%)
        _mint(team, initialSupply.div(2));

        _birthDay = block.timestamp;        
    }    

    receive() external payable {
        if (msg.data.length == 0) {            
            invest(msg.sender, owner());
        }
        else {
            invest(msg.sender, bytesToAddress(msg.data));    
        }       
    }

    function investWithReferrer(uint256 referralNumber) external payable {

        address referrerAddress = userIds[referralNumber];
        require(isUserExists(referrerAddress), "The referral number is not correct.");
        invest(msg.sender, referrerAddress);
    }

    function isEqualString(string memory _a, string memory _b) public pure returns(bool){
    	if(uint(keccak256(abi.encodePacked(_a))) == uint(keccak256(abi.encodePacked(_b)))) {
    		return true;
    	}else{
    		return false;
    	}
    }

    function checkStatus() public returns(string memory) {       
        string[6] memory statusMessage = [
            "The ICO is not started yet.", 
            "The ICO is running.", 
            "The ICO has been ended.", 
            "The ICO has been finished successfully.",
            "The ICO failed. Refunding ether.",
            "The ICO failed. Everything has been refunded successfully."
        ];
        
        if(status == StatusType.Ready){

        }
        else if( status == StatusType.Started) {
            if( block.timestamp > endDate ) {           
                validateResult();
            }
        }        
        else if( status == StatusType.Ended ) {
        }
        else if( status == StatusType.Success ) {
            
        }
        else if( status == StatusType.Failed ) {
            
        }

        emit EventStatus(statusMessage[uint8(status)]);
        
        return statusMessage[uint8(status)];
    }
   
    /**
     * @dev distribute the amount of ETR to airdrop members.
     * @param airdrops The addresses of the special users who invested in this ICO.
     * @param amounts The array of ETR amount that will be transferred to members as airdrop bonus
     */
    function presale(address[] memory airdrops, uint256[] memory amounts)
        public
        onlyOwner
    {
        require(airdrops.length > 0 && amounts.length > 0 && airdrops.length == amounts.length, "Data is not correct.");

        for (uint256 i = 0; i < airdrops.length; i++) {
            _transfer(owner(), airdrops[i], amounts[i]);
        }
    }

    function setStartDate(uint16 year, uint8 month, uint8 day) public onlyOwner {
        require(status == StatusType.Ready, "The ICO already has been executed. Cannot update anymore.");
        startDate = toTimestamp(year, month, day);                
    }

    function setEndDate(uint16 year, uint8 month, uint8 day) public onlyOwner {
        require(status == StatusType.Ready, "The ICO already has been executed. Cannot update anymore.");
        endDate = toTimestamp(year, month, day, 23, 59, 59);        
    }

    function ownerBalance() public view returns (uint256) {
        return balanceOf(owner());
    }

    function getMyInformation() public view  returns (uint256 id, address referrer, uint256 ethAmount, uint256 ethRefunded){
        return getUserInformation(msg.sender);
    }

    function getUserInformation(uint256 userId) public view onlyOwner returns (uint256 id, address referrer, uint256 ethAmount, uint256 ethRefunded){
        require(userId > 0 && userId <= lastUserId, "User ID is not valid.");

        return getUserInformation(userIds[userId]);
    }

    function getMyReferralNumber() public view returns (uint256){
        return getReferralNumber(msg.sender);
    }

    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function withdrawEther() public payable onlyOwner{
        require(status == StatusType.Success || status == StatusType.RefundedAll, "Cannot withdraw Ether until the ICO is completed or until refund all in the case of the ICO failed.");
        require(address(this).balance > 0, "Ether balance is zero.");
        
        msg.sender.transfer(address(this).balance);
    }

    function etherBalance() public view returns (uint256){
        return address(this).balance;
    }
    
    function refundAll() public payable onlyOwner {
        require(status == StatusType.Failed, "It is possible to refund only when the ICO failed.");
        
        status = StatusType.RefundedAll;
        
        for(uint256 idx = 1; idx <= lastUserId; idx ++) {
            address payable userAddress = address(uint160(userIds[idx]));
            User storage user = users[userAddress];
            
            if( user.ethRefunded == 0 ) {
                user.ethRefunded = user.ethAmount;
                userAddress.transfer(user.ethAmount);
            }
        }
    }
    
    function refund() public payable{
        require(isUserExists(msg.sender), "User does not exist.");
        require(status == StatusType.Failed, "Cannot refund now.");

        User storage user = users[msg.sender];
        
        require(user.ethRefunded == 0, "Refunded already.");
        
        user.ethRefunded = user.ethAmount;
        msg.sender.transfer(user.ethAmount);
    }

    function validateResult() private {
        if( totalInvested >= SOFT_CAP ) {
            status = StatusType.Success;
        }
        else {            
            //will refund ether to investors
            status = StatusType.Failed;
        }
    }

    function invest(address userAddress, address referrerAddress) private {
        require(startDate != 0 && endDate != 0 && startDate < endDate, "The configuration was not set yet.");
        require(block.timestamp >= startDate, "ICO is not started yet.");
        require(block.timestamp <= endDate, "ICO has been expired. Please check status.");        
        require(status == StatusType.Ready || status == StatusType.Started, checkStatus());
        require(!isContract(userAddress), "Cannot be a contract");
        require(!isOwner(userAddress), "You are onwer.");
        require(
            msg.value >= INVEST_MIN_AMOUNT,
            "Minimum deposit amount 0.1 ether."
        );

        status = StatusType.Started;

        uint256 ethAmount = msg.value;  //wei
        bool referralBonusFlag = true;
        User storage user;

        if(isUserExists(userAddress)) { //ignore referral bonus
            user = users[userAddress];
            referralBonusFlag = false;
        }
        else {  //new registration
            lastUserId ++;
        
            users[userAddress] = User({
                id: lastUserId,
                referrer: referrerAddress,
                ethAmount: 0,
                ethRefunded: 0
            });
            user = users[userAddress];
            
            userIds[lastUserId] = userAddress;

            if(isOwner(referrerAddress))
                referralBonusFlag = false;
        }

        uint256 refundETH = 0;
        uint256 amount = ethAmount.mul(ETRRATE).div(10**18);
        uint256 bonus = amount.mul((getBounusPercent().add(100)).div(100));
        uint256 referralBonus =  referralBonusFlag ? amount.div(4) : 0; //25%
        uint256 totalAmount = bonus.add(referralBonus);

        if( totalAmount > ownerBalance() ) {
            //available rate = balance / totalAmount
            
            refundETH = ethAmount.sub(ethAmount.mul(ownerBalance()).div(totalAmount));
            ethAmount = ethAmount.sub(refundETH);

            //calculate again
            amount = ethAmount.mul(ETRRATE).div(10**18);
            bonus = amount.mul((getBounusPercent().add(100)).div(100));
            referralBonus =  referralBonusFlag ? amount.div(4) : 0; //25%

            validateResult();
        }

        //send ETR
        _transfer(owner(), userAddress, bonus);
        if( referralBonusFlag ) {
            _transfer(owner(), referrerAddress, referralBonus);
        }

        user.ethAmount = user.ethAmount.add(ethAmount);
        totalInvested = totalInvested.add(ethAmount);
        if( refundETH > 0 ) {
            msg.sender.transfer(refundETH);
        }
    }

    function getReferralNumber(address userAddress) private view returns (uint256){
        require(isUserExists(userAddress), "The user does not exist. Please register.");

        address referrerAddress = users[userAddress].referrer;
        require(referrerAddress != owner(), "You don't have any referrer.");
        
        return users[referrerAddress].id;
    }
    
    function getUserInformation(address userAddress) private view returns(uint256 id, address referrer, uint256 ethAmount, uint256 ethRefunded) {
        require(isUserExists(userAddress), "The user does not exist.");
        
        User memory user = users[userAddress];
        id = user.id;
        referrer = user.referrer;
        ethAmount = user.ethAmount;
        ethRefunded = user.ethRefunded;
    }

    /**
     * Utils
     */
    //////////////////////////////////////////////////////////////////

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    function isLeapYear(uint16 year) private pure returns (bool) {
		if (year % 4 != 0) {
				return false;
		}
		if (year % 100 != 0) {
				return true;
		}
		if (year % 400 != 0) {
				return false;
		}
		return true;
    }

    function toTimestamp(uint16 year, uint8 month, uint8 day) private pure returns (uint32 timestamp) {
		return toTimestamp(year, month, day, 0, 0, 0);
    }

    
    function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) private pure returns (uint32 timestamp) {
        uint32 DAY_IN_SECONDS = 86400;
        uint32 YEAR_IN_SECONDS = 31536000;
        uint32 LEAP_YEAR_IN_SECONDS = 31622400;
    
        uint32 HOUR_IN_SECONDS = 3600;
        uint32 MINUTE_IN_SECONDS = 60;
    
        uint16 ORIGIN_YEAR = 1970;
        
		uint16 i;

		// Year
		for (i = ORIGIN_YEAR; i < year; i++) {
				if (isLeapYear(i)) {
						timestamp += LEAP_YEAR_IN_SECONDS;
				}
				else {
						timestamp += YEAR_IN_SECONDS;
				}
		}

		// Month
		uint8[12] memory monthDayCounts;
		monthDayCounts[0] = 31;
		if (isLeapYear(year)) {
				monthDayCounts[1] = 29;
		}
		else {
				monthDayCounts[1] = 28;
		}
		monthDayCounts[2] = 31;
		monthDayCounts[3] = 30;
		monthDayCounts[4] = 31;
		monthDayCounts[5] = 30;
		monthDayCounts[6] = 31;
		monthDayCounts[7] = 31;
		monthDayCounts[8] = 30;
		monthDayCounts[9] = 31;
		monthDayCounts[10] = 30;
		monthDayCounts[11] = 31;

		for (i = 1; i < month; i++) {
				timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
		}

		// Day
		timestamp += DAY_IN_SECONDS * (day - 1);

		// Hour
		timestamp += HOUR_IN_SECONDS * (hour);

		// Minute
		timestamp += MINUTE_IN_SECONDS * (minute);

		// Second
		timestamp += second;

		return timestamp;
    }

    /**
     * @dev get ICO bonus percent by time(week).
     */
    function getBounusPercent() private view returns (uint256) {
        uint8[5] memory bonusPercents = [200, 100, 50, 25, 0];
        uint256 currentDay = block.timestamp;
        uint256 delta = currentDay.sub(startDate);
        uint256 weekIndex = delta.div(3600 * 24 * 7);

        uint256 bonus = 0;
        if (weekIndex < 4) bonus = bonusPercents[weekIndex];

        return bonus;
    }
}
