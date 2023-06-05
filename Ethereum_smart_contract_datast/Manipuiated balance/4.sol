pragma solidity ^0.4.24;

function withdraw() external onlyByOwner {
    owner.transfer(address(this).balance);
}
