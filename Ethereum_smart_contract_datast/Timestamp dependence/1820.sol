            if (_delta < 6 * 30 days) {
                if (unlockedstep[_locker] == i && i < 9 && i <= _step1 ) {
                } else if (i == 9 && unlockedstep[_locker] == 9 && _step1 == 9){
                if (unlockedstep[_locker] == j && j < 10 && j <= _step2 ) {
                } else if (j == 10 && unlockedstep[_locker] == 10 && _step2 == 10){
        require(now > RELEASE_BASE_TIME);
