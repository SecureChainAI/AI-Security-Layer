function init() public onlyOwner {
    require(!initialized);
    initialized = true;

    if (PAUSED) {
        MainToken(token).pause();
    }

    address[5] memory addresses = [
        address(0xa7c7e82a53baebe36f95b7df4c447b21eadfb60b),
        address(0xa7c7e82a53baebe36f95b7df4c447b21eadfb60b),
        address(0xf3dec80a2d514096027a56110b3fc2b155838679),
        address(0x5eb83c9f93eeb6bf6eb02a1aa9a0815a03c53b2a),
        address(0xd3841ac09b2fe75e3d0486bce88d1f41298ada41)
    ];
    uint[5] memory amounts = [
        uint(13100000000000000000000000),
        uint(29800000000000000000000000),
        uint(600000000000000000000000),
        uint(58850000000000000000000),
        uint(14100000000000000000000000)
    ];
    uint64[5] memory freezes = [
        uint64(1604073601),
        uint64(0),
        uint64(1572451201),
        uint64(0),
        uint64(1572451201)
    ];

    for (uint i = 0; i < addresses.length; i++) {
        if (freezes[i] == 0) {
            MainToken(token).mint(addresses[i], amounts[i]);
        } else {
            MainToken(token).mintAndFreeze(
                addresses[i],
                amounts[i],
                freezes[i]
            );
        }
    }

    transferOwnership(TARGET_USER);

    emit Initialized();
}
