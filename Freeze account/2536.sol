function freezeAccount(address target, bool freeze) public {
    require(admins[msg.sender] == true);
    frozenAccount[target] = freeze;
    emit FrozenFunds(target, freeze);
}
