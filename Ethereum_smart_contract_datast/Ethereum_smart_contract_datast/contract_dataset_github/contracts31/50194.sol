pragma solidity ^0.4.25;

// Slot Machine Logic Contract ///////////////////////////////////////////////////////////
// Author: Decentral Games (hello@decentral.games) ///////////////////////////////////////
import "./SafeMath.sol";

contract SlotMachineLogic {
    using SafeMath for uint256;
    
    uint256[] symbols; // array to hold symbol integer groups

    function getWinAmount(
        uint256 _localhash,
        uint256 jackpot1,
        uint256 jackpot2,
        uint256 jackpot3,
        uint256 jackpot4
    ) public returns (uint256 amountWin, uint256 numbers) {
        // randomly determine number from 0 - 999
        numbers = randomNumber(_localhash) % 1000;
        uint256 number = numbers;

        // look-up table defining groups of winning number (symbol) combinations
        symbols = [4, 4, 4, 4, 3, 3, 3, 2, 2, 1];
        uint256 winner = symbols[number % 10]; // get symbol for rightmost number

        for (uint256 i = 0; i < 2; i++) {
            number = uint256(number) / 10; // shift numbers to get next symbol

            if (symbols[number % 10] != winner) {
                winner = 0;

                break; // if number not part of the winner group (same symbol) break
            }
        }
        if (winner == 1) {
            amountWin = jackpot1;
        } else if (winner == 2) {
            amountWin = jackpot2;
        } else if (winner == 3) {
            amountWin = jackpot3;
        } else if (winner == 4) {
            amountWin = jackpot4;
        } else {
            amountWin = 0;
        }
    }
    
    function setJackpots(uint256 _minimumBet) public pure returns (uint256[4] jackpots) {
        uint256 jackpot1 = _minimumBet.mul(2500).div(10);
        uint256 jackpot2 = _minimumBet.mul(150).div(10);
        uint256 jackpot3 = _minimumBet.mul(80).div(10);
        uint256 jackpot4 = _minimumBet.mul(40).div(10);
        
        jackpots = [jackpot1, jackpot2, jackpot3, jackpot4];
    }

    function randomNumber(uint256 _localhash) private view returns (uint256 numbers) {
        uint256 blockNumber = block.number - 1;
        
        return
            uint256(
                keccak256(abi.encodePacked(blockhash(blockNumber), _localhash))
            );
    }
}
