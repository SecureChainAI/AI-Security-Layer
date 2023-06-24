pragma solidity ^0.4.24;

function airdropSameAmount(
        address[] recipient,
        uint256 amount
    ) public onlyOwner returns (uint256) {
        uint256 i = 0;
        while (i < recipient.length) {
            token.transfer(recipient[i], amount);
            i += 1;
        }
        return (i);
    }
}