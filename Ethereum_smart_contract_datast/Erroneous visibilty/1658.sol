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

function getStats() constant returns (uint256, uint256, uint256, bool) {
    return (
        totalContribution,
        totalSupply,
        totalBonusTokensIssued,
        purchasingAllowed
    );
}
