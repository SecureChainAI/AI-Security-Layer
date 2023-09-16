function extract(
    uint256 _input,
    uint256 _start,
    uint256 _end
) internal pure returns (uint256) {
    // check conditions
    require(_end < 77 && _start < 77, "start/end must be less than 77");
    require(_end >= _start, "end must be >= start");

    // format our start/end points
    _end = exponent(_end).mul(10);
    _start = exponent(_start);

    // return requested section
    return ((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) /
        _start);
}
