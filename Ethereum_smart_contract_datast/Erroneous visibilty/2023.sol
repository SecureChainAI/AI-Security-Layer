function emitTransfer(
    address _from,
    address _to,
    bytes32 _symbol,
    uint _value,
    string _reference
) {
    Transfer(_from, _to, _symbol, _value, _reference, _getVersion());
}

function emitIssue(bytes32 _symbol, uint _value, address _by) {
    Issue(_symbol, _value, _by, _getVersion());
}

function emitRevoke(bytes32 _symbol, uint _value, address _by) {
    Revoke(_symbol, _value, _by, _getVersion());
}

function emitOwnershipChange(address _from, address _to, bytes32 _symbol) {
    OwnershipChange(_from, _to, _symbol, _getVersion());
}

function emitApprove(
    address _from,
    address _spender,
    bytes32 _symbol,
    uint _value
) {
    Approve(_from, _spender, _symbol, _value, _getVersion());
}

function emitRecovery(address _from, address _to, address _by) {
    Recovery(_from, _to, _by, _getVersion());
}

function emitTransferToICAP(
    address _from,
    address _to,
    bytes32 _icap,
    uint _value,
    string _reference
) {
    TransferToICAP(_from, _to, _icap, _value, _reference, _getVersion());
}

function emitError(bytes32 _message) {
    Error(_message, _getVersion());
}
