pragma solidity ^0.4.24;

function selfDestroy(address _address) public onlyOwner {
    // this method will send all money to the following address after finalize
    assert(isFinalized);
    selfdestruct(_address);
}
