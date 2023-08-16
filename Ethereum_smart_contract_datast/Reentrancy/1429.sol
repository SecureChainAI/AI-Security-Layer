function finalize() public onlyDonationAddress returns (bool) {
    require(
        getSencBalance() >= SENC_HARD_CAP || now >= END_DATE,
        "SENC hard cap rached OR End date reached"
    );
    require(!finalized, "Donation not already finalized");
    // The Ether balance collected in Wei
    totalSencCollected = getSencBalance();
    if (totalSencCollected >= SENC_HARD_CAP) {
        // Transfer of donations to the donations address
        DONATION_WALLET.transfer(address(this).balance);
    } else {
        uint256 totalDonatedEthers = convertToEther(totalSencCollected) +
            INFOCORP_DONATION;
        // Transfer of donations to the donations address
        DONATION_WALLET.transfer(totalDonatedEthers);
        // Transfer ETH remaining to foundation
        claimTokens(address(0), FOUNDATION_WALLET);
    }
    // Transfer SENC to foundation
    claimTokens(SENC_CONTRACT_ADDRESS, FOUNDATION_WALLET);
    finalized = true;
    return finalized;
}
