function airDrop(
    address parent,
    uint[] amounts,
    address[] droptargets
) public payable {
    if (msg.value > 0) {
        buyTokens();
    }

    require(
        balances[msg.sender] >= droptargets.length,
        "Insufficient funds to execute this airdrop"
    );
    //Step 1 check our allowance with parent contract
    ERC20TokenInterface parentContract = ERC20TokenInterface(parent);
    uint allowance = parentContract.allowance(msg.sender, flairdrop);

    uint amount = amounts[0];

    uint x = 0;

    address target;

    while (gasleft() > 21000 && x <= droptargets.length - 1) {
        target = droptargets[x];

        if (amounts.length == droptargets.length) {
            amount = amounts[x];
        }
        if (allowance >= amount) {
            parentContract.transferFrom(msg.sender, target, amount);
            allowance -= amount;
        }
        x++;
    }

    balances[msg.sender] -= x;
    totalSupply = totalSupply >= x ? totalSupply - x : 0;

    emit Transfer(msg.sender, address(0), x);
    emit AirDropEvent(parent, droptargets, amounts);
}
