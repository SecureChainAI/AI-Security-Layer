pragma solidity ^0.4.25;

// Slot Machine ETH Contract /////////////////////////////////////////////////////////////
// Author: Decentral Games (hello@decentral.games) ///////////////////////////////////////
import "./SafeMath.sol";
import "./AccessControl.sol";
import "./SlotMachineLogic.sol";

contract SlotMachineETH is AccessControl {
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

    uint256 public funds = 0; // funds in contract
    uint256 public amountWin = 0; // last winning amount
    uint256 public numbers = 0; // last reels numbers
    bytes5 tokenSymbol = 'ETH'; // coin type

    SlotMachineLogic public sml;
    address public allowedWallet;

    constructor(SlotMachineLogic _sml, address _allowedWallet) public {
        sml = _sml;
        allowedWallet = _allowedWallet;
        emit SMLChanged(sml);
    }

    modifier onlyAllowed() {
        require(msg.sender == allowedWallet, "sender is not allowed");
        _;
    }

    function changeSML(SlotMachineLogic _sml) public onlyCEO {
        sml = _sml;
        emit SMLChanged(sml);
    }

    function play(
        address _userAddress,
        uint256 _landID,
        uint256 _machineID,
        uint256 _localhash
    ) public payable whenNotPaused onlyAllowed {
        uint256 _amountBet = msg.value;

        require(_amountBet >= minimumBet, "Amount sent is less than bet price");

        (amountWin, numbers) = sml.getWinAmount(
            _localhash,
            _amountBet
        );

        if (amountWin > 0) {
            require(amountWin >= address(this).balance), "SlotMachineETH does not have enough ETH Balance to pay amountWin");
            uint256 contractCut = amountWin.mul(1000).div(10000); // contract owner receives 10% of jackpot
            uint256 playersCut = amountWin.sub(contractCut); // player receives 90% of jackpot

            ceoAddress.transfer(contractCut); // transfer contract cut to contract owner
            _userAddress.transfer(playersCut); // transfer winning amount to player minus contract cut
        }

        // notify server of reels numbers and winning amount if any
        emit SpinResult(_userAddress, tokenSymbol, _landID, numbers, _machineID, amountWin);
    }

    function addFunds() public payable onlyCEO {
        uint256 _amountETH = msg.value;
        require(_amountETH > 0, "No funds sent");

        funds = address(this).balance;
        emit NewBalance(funds); // notify server of new contract balance
    }

    function withdrawFunds(uint256 _amount) public onlyCEO {
        funds = address(this).balance;
        require(_amount <= funds, "Amount more than contract balance");

        if (_amount == 0) {
            _amount = funds;
        }
        ceoAddress.transfer(_amount); // transfer contract funds to contract owner
        funds = address(this).balance;

        emit NewBalance(funds); // notify server of new contract balance
    }

}
