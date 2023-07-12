if(queryNow()<innerlockStartTime){
			return false;
		}
        if(queryNow()<outterlockStartTime){
			return totalLockAmount;
		}
        if(queryNow()<innerlockStartTime){
			return false;
		}
