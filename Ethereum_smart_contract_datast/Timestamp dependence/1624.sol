        if (atTime < startDate1) {
        } else if (endDate1 > atTime && atTime > startDate1) {
        } else if (endDate2 > atTime && atTime > startDate2) {
 return (
            (getCurrentTimestamp() >= startDate1 &&
                getCurrentTimestamp() < endDate1 && saleCap > 0) ||
            (getCurrentTimestamp() >= startDate2 &&
                getCurrentTimestamp() < endDate2 && saleCap > 0)
                );
        if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {
