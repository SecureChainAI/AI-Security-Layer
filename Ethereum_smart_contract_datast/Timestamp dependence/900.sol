 require(
            txRegistry.getTxTimestampPaymentMCW(txPaymentForMCW) == 0,
            "Tx with such hash is already exist."
        );