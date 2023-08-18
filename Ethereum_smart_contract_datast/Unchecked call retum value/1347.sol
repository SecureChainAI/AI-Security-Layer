function buy(address _referredBy) public payable returns (uint256) {
    purchaseInternal(msg.value, _referredBy);
}

function purchaseInternal(
    uint256 _incomingEthereum,
    address _referredBy
)
    internal
    notContract // no contracts allowed
    returns (uint256)
{
    uint256 purchaseEthereum = _incomingEthereum;
    uint256 excess;
    if (purchaseEthereum > 4 ether) {
        // check if the transaction is over 4 ether
        if (
            SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether
        ) {
            // if so check the contract is less then 100 ether
            purchaseEthereum = 4 ether;
            excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
        }
    }

    purchaseTokens(purchaseEthereum, _referredBy);

    if (excess > 0) {
        msg.sender.transfer(excess);
    }
}
