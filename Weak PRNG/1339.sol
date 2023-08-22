function winnerSelect(uint256 _randomvalue) private {
    //select 2 from all
    for (uint i = 0; i < 2; i++) {
        uint index = doRandom(crrct_prtcpnts, _randomvalue) %
            crrct_prtcpnts.length;

        //remove winner address from the list before doing the transfer
        address _tempAddress = crrct_prtcpnts[index];
        crrct_prtcpnts[index] = crrct_prtcpnts[crrct_prtcpnts.length - 1];
        crrct_prtcpnts.length--;
        lucky_two_prtcpnts.push(_tempAddress);
    }

    uint share = this.getRewardAmount() / 2;
    lucky_two_prtcpnts[0].transfer(share);
    lucky_two_prtcpnts[1].transfer(share);
    emit Winners(lucky_two_prtcpnts, share);
}
