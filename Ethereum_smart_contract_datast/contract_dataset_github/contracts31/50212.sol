pragma solidity ^0.4.25;

// Slot Machine MANA Contract ////////////////////////////////////////////////////////////
// Author: Decentral Games (hello@decentral.games) ///////////////////////////////////////

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

    uint256 public currentIncremental = 1;

    ERC20Token manaToken = ERC20Token(
       // 0x6C4390Ccb2d86a92d33aD73D7E5C5E0bc7cC85a8 // develop
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
    ) public payable whenNotPaused onlyCEO {
        uint256 amountMANA = manaToken.balanceOf(address(this));
         require(amountMANA >= jackpot1, "Insuficient funds in contract");
         require(_amountBet >= minimumBet, "Amount sent is less than bet price");

        manaToken.transferFrom(_userAddress, address(this), _amountBet);

        if(jackpot1 ==0){
            setAmounts(_amountBet);
        }
        (amountWin, numbers) = sml.getWinAmount(
            _localhash,
            jackpot1,
            jackpot2,
            jackpot3,
            jackpot4
        );
        currentIncremental+=1;
        
        if(currentIncremental % 10 == 0){
            jackpot1 += 1 wei;
        }
        
        if(currentIncremental == 1000)
        {
            addFunds(jackpot1);
            currentIncremental = 0;
            setAmounts(_amountBet);

        }

        if (amountWin > 0) {
            manaToken.transfer(_userAddress, amountWin); // transfer winning amount to player
        }

        // notify server of reels numbers and winning amount if any
        emit SpinResult(_userAddress, tokenSymbol, _landID, numbers, _machineID, amountWin);
    }

    function addFunds(uint256 _amountMANA) public onlyCEO {
        require(_amountMANA > 0, "No funds sent");

        manaToken.transferFrom(msg.sender, address(this), _amountMANA);
        funds = manaToken.balanceOf(address(this));

        emit NewBalance(funds); // notify server of new contract balance
    }

    function setAmounts   (uint256 _minimumBet) public payable onlyCEO {
        uint256[4] memory _jackpots;
        minimumBet = _minimumBet;
        
        // set the jackpots for this particular coin
        _jackpots = sml.setJackpots(minimumBet);
        jackpot1 = _jackpots[0];
        jackpot2 = _jackpots[1];
        jackpot3 = _jackpots[2];
        jackpot4 = _jackpots[3];
        
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
