function() public payable whenNotPaused {
    /*
     * check subscription price
     */
    require(msg.value >= PRICE_WEI, "Insufficient Ether");

    /*
     * start round ahead: on QUEUE_MAX + 1
     * draw result
     */
    if (_counter == QMAX) {
        uint r = DMAX;

        uint winpos = 0;

        _blocks.push(block.number);

        bytes32 _a = blockhash(block.number - 1);

        for (uint i = 31; i >= 1; i--) {
            if (uint8(_a[i]) >= 48 && uint8(_a[i]) <= 57) {
                winpos = 10 * winpos + (uint8(_a[i]) - 48);
                if (--r == 0) break;
            }
        }

        _positions.push(winpos);

        /*
         * post out winner rewards
         */
        uint _reward = (QMAX * PRICE_WEI * 90) / 100;
        address _winner = _queue[winpos];

        _winners.push(_winner);
        _winner.transfer(_reward);

        /*
         * update round history
         */
        history storage h = _history[_winner];
        h.prices[h.size - 1] = _reward;

        /*
         * default winner blank comments
         */
        _wincomma.push(0x0);
        _wincommb.push(0x0);

        /*
         * log the win event: winpos is the proof, history trackable
         */
        emit NewWinner(_winner, _round, winpos, h.values[h.size - 1], _reward);

        /*
         * update collectibles
         */
        _collectibles += address(this).balance - _reward;

        /*
         * reset counter
         */
        _counter = 0;

        /*
         * increment round
         */
        _round++;
    }

    h = _history[msg.sender];

    /*
     * user is not allowed to subscribe twice
     */
    require(h.size == 0 || h.rounds[h.size - 1] != _round, "Already In Round");

    /*
     * create user subscription: N.B. places[_round] is the result proof
     */
    h.size++;
    h.rounds.push(_round);
    h.places.push(_counter);
    h.values.push(msg.value);
    h.prices.push(0);

    /*
     * initial round is a push, others are 'on set' index
     */
    if (_round == 0) {
        _queue.push(msg.sender);
    } else {
        _queue[_counter] = msg.sender;
    }

    /*
     * log subscription
     */
    emit NewDropIn(msg.sender, _round, _counter, msg.value);

    /*
     * increment counter
     */
    _counter++;
}
