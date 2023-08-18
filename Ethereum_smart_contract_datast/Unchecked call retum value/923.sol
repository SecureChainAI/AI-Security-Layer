function drop(ERC20 token, address[] recipients, uint256[] values) public {
    for (uint256 i = 0; i < recipients.length; i++) {
        token.transfer(recipients[i], values[i]);
    }
}

function multisend(ERC20 token, address[] recipients, uint256 value) public {
    for (uint256 i = 0; i < recipients.length; i++) {
        token.transfer(recipients[i], value * 1000000000000000000);
    }
}
