function NotaryChain(
    uint256 totalSupply
) DetailedERC20("NotaryChain", "NOTC", 6) {
    totalSupply_ = totalSupply;
    balances[msg.sender] = totalSupply;
}
