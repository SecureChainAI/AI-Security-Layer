function _inverse(uint256 val) public pure returns (uint256 invVal) {
    uint256 t = 0;
    uint256 newT = 1;
    uint256 r = n;
    uint256 newR = val;
    uint256 q;
    while (newR != 0) {
        q = r / newR;

        (t, newT) = (newT, addmod(t, (n - mulmod(q, newT, n)), n));
        (r, newR) = (newR, r - q * newR);
    }

    return t;
}
