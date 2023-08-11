		uint256 periods = now.sub(creationTime.add(_cliff)).div(_periodLength);
		return _unlockedAfterCliff.add(periods.mul(_periodAmount));
	
