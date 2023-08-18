numOfSpecials = (card.level+1)/5; //auto floor to indicate how many Ns for upgradeGemsSpecial; cardlevel +1 is the new level
			uint totalGems = (numOfSpecials * upgradeGemsSpecial) + (((card.level) - numOfSpecials) * upgradeGems);
				function _calculateFee(uint256 _challengeFee) internal view returns (uint256) {
		return developerCut.mul(_challengeFee/10000);
	}