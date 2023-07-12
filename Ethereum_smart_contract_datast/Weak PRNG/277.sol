		return uint16((getRandom() % 10000) + 1); //get 1 to 10000
		uint8 randResult = uint8((getRandom() % 100) + 1); //get 1 to 100
		hash = uint256((getRandom()%1000000000000)/10000000000);		
		uint256 tempHash = ((getRandom()%(eventCardRangeMax-eventCardRangeMin+1))+eventCardRangeMin)*100;
		tempHash = getRandom()%100;
