            if (lockupInfo[_holder][idx].releaseTime <= now) {
        if(releaseAmount >= info.lockupBalance) {            
                if( releaseTimeLock(_holder, idx) ) {
