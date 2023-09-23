function distribute(uint256 _percent) public isHuman {
    // make sure _percent is within boundaries
    require(
        _percent > 0 && _percent < 100,
        "please pick a percent between 1 and 99"
    );

    // data setup
    address _pusher = msg.sender;
    uint256 _bal = address(this).balance;
    uint256 _compressedData;

    // limit pushers greed (use "if" instead of require for level 42 top kek)
    if (
        pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
        pushers_[_pusher].time.add(1 hours) < now // pusher is greedy: its not even been 1 hour
    ) {
        // update pushers wait que
        pushers_[_pusher].tracker = pusherTracker_;
        pusherTracker_++;

        // setup _stop.  this will be used to tell the loop to stop
        uint256 _stop = (_bal.mul(100 - _percent)) / 100;

        // buy & sell
        P3Dcontract_.buy.value(_bal)(address(0));
        P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));

        // setup tracker.  this will be used to tell the loop to stop
        uint256 _tracker = P3Dcontract_.dividendsOf(address(this));

        // reinvest/sell loop
        while (_tracker >= _stop) {
            // lets burn some tokens to distribute dividends to p3d holders
            P3Dcontract_.reinvest();
            P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));

            // update our tracker with estimates (yea. not perfect, but cheaper on gas)
            _tracker = (_tracker.mul(81)) / 100;
        }

        // withdraw
        P3Dcontract_.withdraw();
    } else {
        _compressedData = _compressedData.insert(1, 47, 47);
    }

    // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
    pushers_[_pusher].time = now;

    // prep event compression data
    _compressedData = _compressedData.insert(now, 0, 14);
    _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
    _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
    _compressedData = _compressedData.insert(_percent, 45, 46);

    // fire event
    emit onDistribute(_pusher, _bal, address(this).balance, _compressedData);
}
