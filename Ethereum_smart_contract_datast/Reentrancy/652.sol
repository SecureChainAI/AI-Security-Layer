  function bid(address receiver)
        public
        payable
        isValidPayload
        timedTransitions
        atStage(Stages.AuctionStarted)
        returns (uint amount)
    {
        require(msg.value > 0);
        amount = msg.value;

        // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
        if (receiver == 0)
            receiver = msg.sender;

        // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
        uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
        uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
        if (maxWeiBasedOnTotalReceived < maxWei)
            maxWei = maxWeiBasedOnTotalReceived;

        // Only invest maximum possible amount.
        if (amount > maxWei) {
            amount = maxWei;
            // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
            receiver.transfer(msg.value - amount);
        }

        // Forward funding to ether wallet
        wallet.transfer(amount);

        bids[receiver] += amount;
        totalReceived += amount;
        BidSubmission(receiver, amount);

        // Finalize auction when maxWei reached
        if (amount == maxWei)
            finalizeAuction();
    }
