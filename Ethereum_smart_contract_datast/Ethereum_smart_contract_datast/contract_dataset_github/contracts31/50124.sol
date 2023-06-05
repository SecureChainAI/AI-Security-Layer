pragma solidity ^0.4.25;

// Slot Machine Logic Contract ///////////////////////////////////////////////////////////
// Author: Decentral Games (hello@decentral.games) ///////////////////////////////////////
import "./SafeMath.sol";

contract SlotMachineLogic {
    using SafeMath for uint256;
    
    uint256[] symbols; // array to hold symbol integer groups

    function getWinAmount(
        uint256 _localhash,
        uint256 _amountBet
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
            amountWin = _amountBet.mul(2500).div(100);
        } else if (winner == 2) {
            amountWin = _amountBet.mul(150).div(100);
        } else if (winner == 3) {
            amountWin = _amountBet.mul(80).div(100);
        } else if (winner == 4) {
            amountWin = _amountBet.mul(40).div(100);
        } else {
            amountWin = 0;
        }
    }

    function randomNumber(uint256 _localhash) private view returns (uint256 numbers) {
        uint256 blockNumber = block.number - 1;
        
        return
            uint256(
                keccak256(abi.encodePacked(blockhash(blockNumber), _localhash))
            );
    }
}
