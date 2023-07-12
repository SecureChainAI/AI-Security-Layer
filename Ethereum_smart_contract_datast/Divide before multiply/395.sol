		uint256 epoch=queryNow().sub(innerlockStartTime).div(unlockStepLong);
		uint256 releaseAmount = platformFundingPerEpoch.mul(epoch);
		uint256 epoch=queryNow().sub(innerlockStartTime).div(unlockStepLong);
		uint256 releaseAmount=teamKeepingPerEpoch.mul(epoch);
		uint256 cooperatePerEpoch= totalLockAmount.div(12);
		return cooperatePerEpoch.mul(remainingEpoch);
