            if (add(now, earlier) > add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
            if (add(now, earlier) < add(lockTime[_address][i], later)) _balance = add(_balance, lockValue[_address][i]);
            if (add(now, earlier) > add(currentLockTime[i], later)) {
                lockTime[_to][lockNum[_to]] = add(now, _time[i]);
                lockTime[_to][lockNum[_to]] = add(now, _time[i]);
