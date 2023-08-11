require(requestIds[_requestId] >= latestUpdate, "Result is stale");
        require(requestIds[_requestId] <= now + oraclizeTimeTolerance, "Result is early");
        if (latestUpdate != 0) {
                require(_times[i] >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
                if (maximumScheduledUpdated < requestIds[requestId]) {
        if (latestScheduledUpdate < maximumScheduledUpdated) {
        require(_startTime >= now, "Past scheduling is not allowed and scheduled time should be absolute timestamp");
        if (latestScheduledUpdate < requestIds[requestId]) {
        require(latestUpdate >= now - staleTime);
