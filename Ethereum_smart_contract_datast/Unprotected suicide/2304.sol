function setup(uint8 _state, bytes32[] _params) external {
    require(rightAndRoles.onlyRoles(msg.sender, 1));

    if (_state == 0) {
        require(_params.length == 1);
        // call from Crowdsale.distructVault(true) for exit
        // arg1 - nothing
        // arg2 - nothing
        selfdestruct(address(_params[0]));
    } else if (_state == 1) {
        require(_params.length == 0);
        // Call from Crowdsale.finalization()
        //   [1] - successfull round (goalReach)
        //   [3] - failed round (not enough money)
        // arg1 = weiTotalRaised();
        // arg2 = nothing;

        require(state == State.Active);
        //internalCalc(_arg1);
        state = State.Closed;
        emit Closed();
    } else if (_state == 2) {
        require(_params.length == 0);
        // Call from Crowdsale.initialization()
        // arg1 = weiTotalRaised();
        // arg2 = nothing;
        require(state == State.Closed);
        require(address(this).balance == 0);
        state = State.Active;
        step++;
        emit Started();
    } else if (_state == 3) {
        require(_params.length == 0);
        require(state == State.Active);
        state = State.Refunding;
        emit RefundsEnabled();
    } else if (_state == 4) {
        require(_params.length == 2);
        //onlyPartnersOrAdmin(address(_params[1]));
        internalCalc(uint256(_params[0]));
    } else if (_state == 5) {
        // arg1 = old ETH/USD (exchange)
        // arg2 = new ETH/USD (_ETHUSD)
        require(_params.length == 2);
        for (uint8 user = 0; user < cap.length; user++)
            cap[user] = cap[user].mul(uint256(_params[0])).div(
                uint256(_params[1])
            );
    }
}
