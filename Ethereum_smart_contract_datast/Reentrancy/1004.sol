function doAirdrop(
    address _tokenAddr,
    address[] dests,
    uint256[] values
) public returns (uint256) {
    uint256 i = 0;
    while (i < dests.length) {
        ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
        i += 1;
    }
    return (i);
}
