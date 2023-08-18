function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _extraData
) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);

    if (
        !_spender.call(
            bytes4(
                bytes32(
                    keccak256("receiveApproval(address,uint256,address,bytes)")
                )
            ),
            msg.sender,
            _value,
            this,
            _extraData
        )
    ) {
        revert();
    }
    return true;
}
