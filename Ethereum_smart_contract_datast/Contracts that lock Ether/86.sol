pragma solidity ^0.4.23;

function lockTransfer(bool _lock) public onlyOwner {
    lockTransfers = _lock;
}
