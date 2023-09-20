function transfer(address _to, uint256 _value);

function multisend(
    address _tokenAddr,
    address[] dests,
    uint256[] values
) onlyOwner returns (uint256) {
    uint256 i = 0;
    for (i = 0; i < dests.length; i++) {
        ERC20(_tokenAddr).transfer(dests[i], values[i]);
    }
    return (i);
}
