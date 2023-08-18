            pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
        pushers_[_pusher].time = now;
        _compressedData = _compressedData.insert(now, 0, 14);
