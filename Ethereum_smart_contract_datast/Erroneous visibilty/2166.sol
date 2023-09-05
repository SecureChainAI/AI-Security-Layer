function burn(uint burnAmount) {
    address burner = msg.sender;
    balances[burner] = balances[burner].sub(burnAmount);
    totalSupply_ = totalSupply_.sub(burnAmount);
    Burned(burner, burnAmount);

    // Inform the blockchain explores that track the
    // balances only by a transfer event that the balance in this
    // address has decreased
    Transfer(burner, BURN_ADDRESS, burnAmount);
}

function setTokenInformation(string _name, string _symbol) onlyOwner {
    name = _name;
    symbol = _symbol;

    UpdatedTokenInformation(name, symbol);
}
