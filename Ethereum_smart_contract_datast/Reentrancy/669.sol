function outSdcForUser(uint256 _sdc) public returns (bool b) {
    // cha kan jie suo de jin e bing tian jia
    for (uint i = 0; i < accountInputSdcs[msg.sender].length; i++) {
        if (now >= accountInputSdcs[msg.sender][i].locktime) {
            unlockSdc[msg.sender] =
                unlockSdc[msg.sender] +
                accountInputSdcs[msg.sender][i].sdc;
            accountInputSdcs[msg.sender][i] = accountInputSdc(
                msg.sender,
                0,
                999999999999,
                now
            );
        }
    }
    //kou qian
    require(unlockSdc[msg.sender] >= _sdc);
    sdcCon.transfer(msg.sender, _sdc);
    unlockSdc[msg.sender] = unlockSdc[msg.sender] - _sdc;
    lockLogs(msg.sender, msg.sender, _sdc, now, false);
    accountOutputSdcs[msg.sender].push(accountOutputSdc(msg.sender, _sdc, now));
    accoutInputOutputSdcLogs[msg.sender].push(
        accoutInputOutputSdcLog(msg.sender, _sdc, 999999999999, false, now)
    );
    return true;
}
