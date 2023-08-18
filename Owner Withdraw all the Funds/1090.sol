function withdrawEther(uint256 amount) public {
    require(msg.sender == owner);
    owner.transfer(amount);
}
