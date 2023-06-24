pragma solidity 0.4.24;

function() public {
    mark();
}

function mark() internal {
    markId++;
    marked[msg.sender]++;
    marks[markId] = abi.encodePacked(msg.sender, msg.data);
}
