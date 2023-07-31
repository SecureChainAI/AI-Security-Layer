function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _extraData
) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);

    //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
    //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
    //假设这么做是可以成功，不然应该调用vanilla approve。
    if (
        !_spender.call(
            bytes4(
                bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))
            ),
            msg.sender,
            _value,
            this,
            _extraData
        )
    ) {
        throw;
    }
    return true;
}
