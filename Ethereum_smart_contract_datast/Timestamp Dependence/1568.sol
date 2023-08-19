function depositMintAndPay(
    address _to,
    uint256 _amount,
    uint _kindOfPackage
) private canMint returns (bool) {
    require(userPackages[_to].since == 0);
    _amount = _amount.mul(rate);
    if (depositMint(_to, _amount, _kindOfPackage)) {
        payToReferer(_to, _amount, "deposit");
        lastPayoutAddress[_to] = now;
    }
}
