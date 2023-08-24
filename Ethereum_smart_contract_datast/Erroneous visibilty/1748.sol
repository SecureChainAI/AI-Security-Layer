function freezeTransfers() {
    require(msg.sender == owner);

    if (!frozen) {
        frozen = true;
        emit Freeze();
    }
}

function refundTokens(address _token, address _refund, uint256 _value) {
    require(msg.sender == owner);
    require(_token != address(this));
    AbstractToken token = AbstractToken(_token);
    token.transfer(_refund, _value);
    emit RefundTokens(_token, _refund, _value);
}

function freezeAccount(address _target, bool freeze) {
    require(msg.sender == owner);
    require(msg.sender != _target);
    frozenAccount[_target] = freeze;
    emit FrozenFunds(_target, freeze);
}
