function getEth(uint num) public payable onlyOwner {
    owner.transfer(num);
}
