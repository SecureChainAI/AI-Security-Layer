function refundTokens(address _token, address _refund, uint256 _value) {
    require(msg.sender == owner);
    require(_token != address(this));
    AbstractToken token = AbstractToken(_token);
    token.transfer(_refund, _value);
    emit RefundTokens(_token, _refund, _value);
}
