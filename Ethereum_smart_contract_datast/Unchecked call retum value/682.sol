function Airdrop(ERC20 token, address[] _addresses, uint256 amount) public {
    for (uint256 i = 0; i < _addresses.length; i++) {
        token.transfer(_addresses[i], amount);
    }
}
