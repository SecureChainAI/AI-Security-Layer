function pointAdd(Point p1, Point p2) internal view returns (Point r) {
    uint256[4] memory input;
    input[0] = p1.X;
    input[1] = p1.Y;
    input[2] = p2.X;
    input[3] = p2.Y;
    bool success;
    assembly {
        success := staticcall(sub(gas, 2000), 6, input, 0x80, r, 0x40)
        switch success
        case 0 {
            invalid()
        }
    }
    require(success);
}
