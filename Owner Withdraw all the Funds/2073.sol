function withdrawEther(uint256 amount) public {
    if (msg.sender != owner) revert();
    owner.transfer(amount);
}
