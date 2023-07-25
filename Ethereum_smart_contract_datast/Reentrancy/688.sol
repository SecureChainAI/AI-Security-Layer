function() public payable {
    if (IsDistribRunning) {
        uint256 _amount;
        if (
            ((_CurrentDistribPublicSupply + _amount) >
                _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0
        ) revert();
        if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
        if (Claimed[msg.sender] == false) {
            _amount = _FreeQPY * 1e18;
            _CurrentDistribPublicSupply += _amount;
            balances[msg.sender] += _amount;
            _totalSupply += _amount;
            Transfer(this, msg.sender, _amount);
            Claimed[msg.sender] = true;
        }

        if (msg.value >= 9e15) {
            _amount = msg.value * _ExtraTokensPerETHSended * 4;
        } else {
            if (msg.value >= 6e15) {
                _amount = msg.value * _ExtraTokensPerETHSended * 3;
            } else {
                if (msg.value >= 3e15) {
                    _amount = msg.value * _ExtraTokensPerETHSended * 2;
                } else {
                    _amount = msg.value * _ExtraTokensPerETHSended;
                }
            }
        }

        _CurrentDistribPublicSupply += _amount;
        balances[msg.sender] += _amount;
        _totalSupply += _amount;
        Transfer(this, msg.sender, _amount);
    } else {
        revert();
    }
}
