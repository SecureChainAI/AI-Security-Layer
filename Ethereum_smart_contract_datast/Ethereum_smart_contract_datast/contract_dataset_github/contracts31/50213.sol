pragma solidity ^0.4.25;

// Slot Machine MANA Contract ////////////////////////////////////////////////////////////
// Author: Decentral Games (hello@decentral.games) ///////////////////////////////////////
import "./SafeMath.sol";
import "./AccessControl.sol";
import "./ERC20Token.sol";
import "./SlotMachineLogic.sol";

contract SlotMachineMANA is AccessControl {
    using SafeMath for uint256;

    // emit events to server node.js events handler
    event SpinResult(
        address _walletAddress,
        bytes5 _tokenSymbol,
        uint256 _landID,
        uint256 indexed _number,
        uint256 indexed _machineID,
        uint256 indexed _amountWin
    );
    event NewBalance(uint256 indexed _balance);
    event SMLChanged(address indexed sml);

    uint256 public minimumBet = 0; // contract's bet price
    uint256 public jackpot1 = 0; // top jackpot amount
    uint256 public jackpot2 = 0; // second jackpot amount
    uint256 public jackpot3 = 0; // third jackpot amount
    uint256 public jackpot4 = 0; // fourth jackpot amount

    uint256 public funds = 0; // funds in contract
    uint256 public amountWin = 0; // last winning amount
    uint256 public numbers = 0; // last reels numbers
    bytes5 tokenSymbol = 'MANA'; // coin type

    ERC20Token manaToken = ERC20Token(
        0xDd1B834a483fD754c8021FF0938f69C1d10dA81F // Matic
        // 0x2a8Fd99c19271F4F04B1B7b9c4f7cF264b626eDB // Ropsten
    );

    SlotMachineLogic public sml;

    constructor(SlotMachineLogic _sml) public {
        sml = _sml;
        emit SMLChanged(sml);
    }

    function changeSML(SlotMachineLogic _sml) public onlyCEO {
        sml = _sml;
        emit SMLChanged(sml);
    }

    function play(
        address _userAddress,
        uint256 _landID,
        uint256 _amountBet,
        uint256 _machineID,
        uint256 _localhash
    ) public whenNotPaused onlyCEO returns (address, bytes5, uint256[]) {
        uint256 amountMANA = manaToken.balanceOf(address(this));
        require(amountMANA >= jackpot1, "Insuficient funds in contract");
        require(_amountBet >= minimumBet, "Amount sent is less than bet price");

        manaToken.transferFrom(_userAddress, address(this), _amountBet);

        (amountWin, numbers) = sml.getWinAmount(
            _localhash,
            jackpot1,
            jackpot2,
            jackpot3,
            jackpot4
        );

        if (amountWin > 0) {
            manaToken.transfer(_userAddress, amountWin); // transfer winning amount to player
        }

        uint256[] memory returnArray = new uint256[](6);
        returnArray[0] = _landID;
        returnArray[1] = numbers;
        returnArray[2] = _machineID;
        returnArray[3] = amountWin;
        returnArray[4] = _amountBet;
        // notify server of reels numbers and winning amount if any
        return (_userAddress, tokenSymbol, returnArray);
    }

    event PlaySettled(address user, bool outcome, uint256 amountWon);
    function settlePlay(address _userAddress, bool _outcome, uint256 _amountBet, uint256 _amountWon) public onlyCEO {
        require(_userAddress != address(0), "Provided user address is not valid");


        require(manaToken.transferFrom(_userAddress, address(this), _amountBet), "transfer from user from contract failed");
        if(_outcome) {
            require(manaToken.transfer(_userAddress, _amountWon), "transfer from contract to user failed");
        }

        emit PlaySettled(_userAddress, _outcome, _amountWon);
    }

    function addFunds(uint256 _amountMANA) public onlyCEO {
        require(_amountMANA > 0, "No funds sent");

        manaToken.transferFrom(msg.sender, address(this), _amountMANA);
        funds = manaToken.balanceOf(address(this));

        emit NewBalance(funds); // notify server of new contract balance
    }

    function setAmounts(uint256 _minimumBet) public onlyCEO {
        uint256[4] memory jackpots;
        minimumBet = _minimumBet;
        
        // set the jackpots for this particular coin
        jackpots = sml.setJackpots(minimumBet);
        jackpot1 = jackpots[0];
        jackpot2 = jackpots[1];
        jackpot3 = jackpots[2];
        jackpot4 = jackpots[3];
    }

    function withdrawFunds(uint256 _amount) public onlyCEO {
        funds = manaToken.balanceOf(address(this));
        require(_amount <= funds, "Amount more than contract balance");

        if (_amount == 0) {
            _amount = funds;
        }
        manaToken.transfer(ceoAddress, _amount); // transfer contract funds to contract owner
        funds = manaToken.balanceOf(address(this));

        emit NewBalance(funds); // notify server of new contract balance
    }

}
