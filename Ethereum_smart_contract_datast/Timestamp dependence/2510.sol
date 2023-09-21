return now - heartBeat < maxTimeIntervalHB;
require(now - lastTimePriceSet > 23 hours);
require(now > earliestNextSettlementTimestamp, "A settlement can happen once per day");
require(custodiesServedETH[lastSettlementStartedTimestamp][_custodies[flowIndex]] == false);
require(custodiesServedBBD[lastSettlementStartedTimestamp][_custodies[flowIndex]] == false);
