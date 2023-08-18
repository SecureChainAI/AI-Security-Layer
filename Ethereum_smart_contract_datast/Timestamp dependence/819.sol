        return (startTime != 0 && now > startTime);
        return now <= limitDateSale;
        return (isWithinSaleTimeLimit() && isWithinSaleLimit(_tokens));
        bool withinPeriod = now >= startTime && now <= endTime; 
        return (withinPeriod && nonZeroPurchase) && withinCap && isWithinSaleTimeLimit();
        return (endTime != 0 && now > endTime) || capReached;
