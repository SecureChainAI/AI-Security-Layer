function kill(
    address _to
) external onlymanyowners(keccak256(abi.encodePacked(msg.data))) {
    selfdestruct(_to);
}
