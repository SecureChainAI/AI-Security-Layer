function freezeAccount(address target, bool freeze) public {
    require(msg.sender == owner); // Only the contract owner can freeze an ethereum wallet
    frozenAccount[target] = freeze; // Freezes the target ethereum wallet
    emit FrozenFunds(target, freeze);
}
