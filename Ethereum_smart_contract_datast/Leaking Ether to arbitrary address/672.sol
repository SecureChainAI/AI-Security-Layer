function hillpayout() internal {
    require(
        block.number >
            roundvars[round].lastblockpayout.add(
                roundvars[round].blocksbeforenewpay
            )
    );
    // new payout method
    roundvars[round].lastblockpayout = roundvars[round].lastblockpayout.add(
        roundvars[round].blocksbeforenewpay
    );
    ethforp3dbuy = ethforp3dbuy.add(
        (address(this).balance.sub(ethforp3dbuy)).div(100)
    );
    owner.transfer((address(this).balance.sub(ethforp3dbuy)).div(100));
    roundvars[round].ATPO = roundvars[round].ATPO.add(
        (address(this).balance.sub(ethforp3dbuy)).div(2)
    );
    roundownables[round].hillowner.transfer(
        (address(this).balance.sub(ethforp3dbuy)).div(2)
    );
}
