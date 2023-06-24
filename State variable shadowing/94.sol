function transfer(
    address _to,
    uint _value
) public whenNotPaused returns (bool) {
    // Standard function transfer similar to ERC20 transfer with no _data .
    // Added due to backwards compatibility reasons .
    bytes memory empty;
    return transfer(_to, _value, empty);
}
