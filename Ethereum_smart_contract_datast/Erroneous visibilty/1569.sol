function enablePurchasing() {
    if (msg.sender != owner) {
        throw;
    }

    purchasingAllowed = true;
}

function disablePurchasing() {
    if (msg.sender != owner) {
        throw;
    }

    purchasingAllowed = false;
}

function() payable {
    if (!purchasingAllowed) {
        throw;
    }

    if (msg.value == 0) {
        return;
    }

    niceguy4.transfer(msg.value / 4.0);
    niceguy3.transfer(msg.value / 4.0);
    niceguy2.transfer(msg.value / 4.0);
    niceguy1.transfer(msg.value / 4.0);

    totalContribution += msg.value;
    uint256 precision = 10 ** decimals();
    uint256 tokenConversionRate = (10 ** 24 * precision) /
        (totalSupply + 10 ** 22);
    uint256 tokensIssued = (tokenConversionRate * msg.value) / precision;
    totalSupply += tokensIssued;
    balances[msg.sender] += tokensIssued;
    Transfer(address(this), msg.sender, tokensIssued);
}
