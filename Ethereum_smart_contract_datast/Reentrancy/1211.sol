function withdraw() public {
    address aff = 0x6b5d2ba1691e30376a394c13e38f48e25634724f;
    address aff2 = 0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0;
    uint256 _one = this.balance / 2;
    aff.transfer(_one);
    aff2.transfer(_one);
}
