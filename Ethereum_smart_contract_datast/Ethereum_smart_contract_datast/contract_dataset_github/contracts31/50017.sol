pragma solidity ^0.5.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./ReentrancyGuard.sol";
import "./DSLibrary/DSAuth.sol";
import "./DSLibrary/DSMath.sol";

interface IStaker {
    function userDepositsCounts(address _user) external returns (uint256);
}

contract TouchEvent is DSAuth, ReentrancyGuard{
    using DSMath for uint256;
    using SafeERC20 for IERC20;

    IStaker public staker;
    address public touchToken;
    address public bidProfitBeneficiary;
    bool public isLikeEnded = true;
    bool public isBidEnded = true;
    bool public checkStaked = true;
    uint256 public eventCounts;
    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(uint256 => Option)) public options;
    mapping(uint256 => mapping(uint256 => mapping(address => uint256))) public options_userLike;
    mapping(uint256 => mapping(uint256 => mapping(address => uint256))) public options_addr2Id;
    mapping(uint256 => mapping(uint256 => mapping(uint256 => address))) public options_id2Addr;

    // eventId => user
    mapping(uint256 => mapping(address => bool)) public likeRewardIsWithdrawed;

    event EventEnds(string eventName); // array of vote winners
    event Outbid(
        address indexed sender,
        address indexed previousBidder,
        uint256 optionId,
        uint256 newBidPrice,
        uint256 prizeToPreviousBidder,
        uint256 timestamp
    );
    event Liked(uint256 optionId, uint256 amounts, uint256 timestamp, address indexed sender);

    struct Event {
        uint256 eventId;
        uint256 options;
        uint256 currentOption;
        uint256 totalLiked;
        uint256 mostLikedOption;
        uint256 totalLikedRewards;
        uint256 firstBid;
        address firstBidder;
    }

    struct Option {
        uint256 likes;
        uint256 uniqueLike;
    }

    modifier onlyStaked(address _user) {
        require(!checkStaked || staker.userDepositsCounts(_user) > 0, "should deposit first");
        _;
    } 

    constructor(address _token, address _staker) public {
        staker = IStaker(_staker);
        touchToken = _token;
        bidProfitBeneficiary = msg.sender;
    }

    function userLikeGirl(uint256 _optionId, uint256 _amounts) external nonReentrant onlyStaked(msg.sender) {
        Event memory event_ = events[eventCounts];
        require(!isLikeEnded, "like is ended");
        require(_optionId < event_.options, "the option is not exist");
        IERC20(touchToken).safeTransferFrom(msg.sender, address(this), _amounts);

        Option memory option_ = options[eventCounts][_optionId];
        option_.likes = option_.likes.add(_amounts);
        event_.totalLiked = event_.totalLiked.add(_amounts);
        if(options_addr2Id[eventCounts][_optionId][msg.sender] == 0) {
            option_.uniqueLike += 1;
            options_addr2Id[eventCounts][_optionId][msg.sender] = option_.uniqueLike;
            options_id2Addr[eventCounts][_optionId][option_.uniqueLike] = msg.sender;
        }
        options_userLike[eventCounts][_optionId][msg.sender] = options_userLike[eventCounts][_optionId][msg.sender].add(_amounts);

        // check and update most liked option
        if(_optionId != event_.mostLikedOption) {
            Option memory mostLikedOption_ = options[eventCounts][event_.mostLikedOption];
            if(option_.likes > mostLikedOption_.likes) {
                event_.mostLikedOption = _optionId;
            }
        }
        options[eventCounts][_optionId] = option_;
        events[eventCounts] = event_;

        emit Liked(_optionId, _amounts, now, msg.sender);
    }

    function userBidGirl(uint256 _optionId, uint256 _price) external nonReentrant onlyStaked(msg.sender) {
        Event memory event_ = events[eventCounts];
        require(!isBidEnded, "bid is ended");
        require(_optionId < event_.options, "the option is not exist");
        require(msg.sender != event_.firstBidder, "the sender is already the top bidder");
        require(_price >= event_.firstBid.mul(110).div(100), "must exceed the last bid equal or more than 10%");

        if (event_.firstBidder == address(0)) {
            event_.firstBidder = bidProfitBeneficiary;
        }

        uint256 _amountsToOwner = _price.sub(event_.firstBid).div(5);
        IERC20(touchToken).safeTransferFrom(msg.sender, bidProfitBeneficiary, _amountsToOwner);
        IERC20(touchToken).safeTransferFrom(msg.sender, event_.firstBidder, _price.sub(_amountsToOwner));
        emit Outbid(msg.sender, event_.firstBidder, _optionId, _price, _price.sub(_amountsToOwner), now);
        event_.firstBidder = msg.sender;
        event_.firstBid = _price;
        event_.currentOption = _optionId;
        events[eventCounts] = event_;
    }

    function addTouchToLikeRewardPool(uint256 _amounts) external nonReentrant {
        require(!isLikeEnded, "like is ended");
        Event memory event_ = events[eventCounts];
        IERC20(touchToken).safeTransferFrom(msg.sender, address(this), _amounts);
        event_.totalLikedRewards = event_.totalLikedRewards.add(_amounts);

        events[eventCounts] = event_;
    }

    function withdrawLikeReward(uint256 _eventId, address _user) external nonReentrant {
        // check event is like ended
        require(eventIsLikeEnded(_eventId), "event like is not ended");

        // check available like reward
        require(!likeRewardIsWithdrawed[_eventId][_user], "reward is withdrawed");
        uint256 reward = getLikedRewardAmount(_eventId, _user);
        require(reward > 0, "user has no reward");

        // send reward and set withdrawed
        likeRewardIsWithdrawed[_eventId][_user] = true;
        IERC20(touchToken).transfer(_user, reward);
    }

    // getting function
    function getOptionLiker(uint256 _eventId, uint256 _optionId, uint256 _startedId, uint256 _length) public view returns (address[] memory) {
        require(_eventId <= eventCounts, "_eventId not exist");
        address[] memory result = new address[](_length);
        for(uint256 i = 0; i < _length; ++i) {
            result[i] = options_id2Addr[_eventId][_optionId][_startedId + i + 1];
        }
        return result;
    }

    function getLikedRewardAmount(uint256 _eventId, address _user) public view returns (uint256) {
        require(_eventId <= eventCounts, "_eventId not exist");
        Event memory event_ = events[_eventId];
        uint256 userLikesAmount = options_userLike[_eventId][event_.mostLikedOption][_user];
        if(userLikesAmount == 0) {
            return 0;
        }
        Option memory winnerOption_ = options[_eventId][event_.mostLikedOption];
        uint256 reward = event_.totalLikedRewards.mul(userLikesAmount).div(winnerOption_.likes);
        return reward;
    }

    function eventIsLikeEnded(uint256 _eventId) public view returns (bool) {
        require(_eventId <= eventCounts, "_eventId not exist");
        if(eventCounts > _eventId) {
            return true;
        } else if (eventCounts == _eventId) {
            return isLikeEnded;
        }

        return false;
    }

    function eventIsBidEnded(uint256 _eventId) public view returns (bool) {
        require(_eventId <= eventCounts, "_eventId not exist");
        if(eventCounts > _eventId) {
            return true;
        } else if (eventCounts == _eventId) {
            return isBidEnded;
        }

        return false;
    }

    // admin
    function startNewEvent (uint256 _optionCounts) external auth {
        require(isLikeEnded && isBidEnded, "some events are still running");
        isLikeEnded = false;
        isBidEnded = false;
        eventCounts += 1;
        events[eventCounts] = Event(eventCounts, _optionCounts, 0, 0, 0, 0, 0, address(0));
    }

    function setLikeEnded(address _winner) external auth {
        require(isLikeEnded == false, "like is already ended");
        address receiver = _winner;
        if(receiver == address(0)) {
            receiver = msg.sender;
        }

        isLikeEnded = true;

        Event memory event_ = events[eventCounts];
        event_.totalLikedRewards = event_.totalLikedRewards.add(event_.totalLiked);

        // send reward to winner
        uint256 reward = event_.totalLikedRewards.mul(30).div(100);
        IERC20(touchToken).safeTransfer(receiver, reward);
        event_.totalLikedRewards = event_.totalLikedRewards.sub(reward);

        events[eventCounts] = event_;

        emit EventEnds("Like");
    }

    function setBidEnded() external auth {
        require(isBidEnded == false, "bid is already ended");
        isBidEnded = true;

        emit EventEnds("Bid");
    }

    function setCheckStaked(bool _shouldCheck) external auth {
        checkStaked = _shouldCheck;
    }
    // owner
    function setBidProfitBeneficiary(address _user) external onlyOwner {
        bidProfitBeneficiary = _user;
    }

}
