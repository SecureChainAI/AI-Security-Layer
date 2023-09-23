function buyp3d(uint256 amt) internal {
    P3Dcontract_.buy.value(amt)(this);
}
