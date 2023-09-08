function pushData() public payable {
    uint _key = now - (now % 86400);
    uint _calledTime = now;
    QueryInfo storage currentQuery = info[queryIds[_key]];
    require(
        (currentQuery.queried == false && currentQuery.calledTime == 0) ||
            (currentQuery.calledTime != 0 &&
                _calledTime >= (currentQuery.calledTime + 3600) &&
                currentQuery.value == 0)
    );
    if (oraclize_getPrice("URL") > address(this).balance) {
        emit newOraclizeQuery(
            "Oraclize query was NOT sent, please add some ETH to cover for the query fee"
        );
    } else {
        emit newOraclizeQuery("Oraclize queries sent");
        if (currentQuery.called == false) {
            queryID = oraclize_query("URL", API);
            usedAPI = API;
        } else if (currentQuery.called == true) {
            queryID = oraclize_query("URL", API2);
            usedAPI = API2;
        }

        queryIds[_key] = queryID;
        currentQuery = info[queryIds[_key]];
        currentQuery.queried = true;
        currentQuery.date = _key;
        currentQuery.calledTime = _calledTime;
        currentQuery.called = !currentQuery.called;
    }
}
