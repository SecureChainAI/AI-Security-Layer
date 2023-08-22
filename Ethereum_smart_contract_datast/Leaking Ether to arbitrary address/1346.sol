function spend(
    address destination,
    uint256 value,
    uint8 v1,
    bytes32 r1,
    bytes32 s1,
    uint8 v2,
    bytes32 r2,
    bytes32 s2
) public {
    // This require is handled by generateMessageToSign()
    // require(destination != address(this));
    require(address(this).balance >= value, "3");
    require(_validSignature(destination, value, v1, r1, s1, v2, r2, s2), "4");
    spendNonce = spendNonce + 1;
    destination.transfer(value);
    emit Spent(destination, value);
}
