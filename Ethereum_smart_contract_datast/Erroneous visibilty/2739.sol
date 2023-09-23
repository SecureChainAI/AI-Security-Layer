function AbstractToken() {
    // Do nothing
}

function PRHXToken() {
    owner = msg.sender;
}

function setOwner(address _newOwner) {
    require(msg.sender == owner);

    owner = _newOwner;
}
