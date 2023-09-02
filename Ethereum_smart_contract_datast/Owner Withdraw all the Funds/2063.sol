function collectEtherBack() public onlyOwner {
    uint256 b = address(this).balance;
    require(b > 0);
    require(collectorAddress != 0x0);

    collectorAddress.transfer(b);
}
