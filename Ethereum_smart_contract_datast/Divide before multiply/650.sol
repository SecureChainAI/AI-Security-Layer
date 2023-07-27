		uint256 epoch=now.sub(startTime).div(unlockStepLong);
		uint256 releaseAmount = platformFundingPerEpoch.mul(epoch);
		uint256 epoch=now.sub(startTime).div(unlockStepLong);
		uint256 releaseAmount=teamKeepingPerEpoch.mul(epoch);
		uint256 cooperatePerEpoch= totalLockAmount.div(36);
		return cooperatePerEpoch.mul(remainingEpoch);
