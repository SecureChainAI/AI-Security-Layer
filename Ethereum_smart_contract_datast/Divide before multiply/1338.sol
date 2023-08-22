function _reAdjustDifficulty() internal {
    uint ethBlocksSinceLastDifficultyPeriod = block.number -
        latestDifficultyPeriodStarted;
    //assume 240 ethereum blocks per hour

    //we want miners to spend 7 minutes to mine each 'block', about 28 ethereum blocks = one 0xGOLD epoch
    uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256

    uint targetEthBlocksPerDiffPeriod = epochsMined * 28; //should be 28 times slower than ethereum

    //if there were less eth blocks passed in time than expected
    if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
        uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div(
            ethBlocksSinceLastDifficultyPeriod
        );

        uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(
            1000
        );
        // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.

        //make it harder
        miningTarget = miningTarget.sub(
            miningTarget.div(2000).mul(excess_block_pct_extra)
        ); //by up to 50 %
    } else {
        uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100))
            .div(targetEthBlocksPerDiffPeriod);
        uint shortage_block_pct_extra = shortage_block_pct
            .sub(100)
            .limitLessThan(1000); //always between 0 and 1000

        //make it easier
        miningTarget = miningTarget.add(
            miningTarget.div(2000).mul(shortage_block_pct_extra)
        ); //by up to 50 %
    }

    latestDifficultyPeriodStarted = block.number;

    if (miningTarget < _MINIMUM_TARGET) //very difficult
    {
        miningTarget = _MINIMUM_TARGET;
    }

    if (miningTarget > _MAXIMUM_TARGET) //very easy
    {
        miningTarget = _MAXIMUM_TARGET;
    }
}
