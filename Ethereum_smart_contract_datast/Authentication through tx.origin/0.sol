pragma solidity ^0.4.24;

function() public payable notLock {
    require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");
    require(isNotContract(msg.sender), "msg.sender not is Contract");
    require(msg.value == curConfig.singlePrice, "msg.value error");
    totalPrice = totalPrice + msg.value;
    addressArray.push(msg.sender);

    emit addPlayerEvent(gameIndex, msg.sender);
    if (addressArray.length >= curConfig.totalSize) {
        gameResult();
        startNewGame();
    }
}
