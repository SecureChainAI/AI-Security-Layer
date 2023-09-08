        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE1] < COSIGN_MAX_TIME)
        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE2] < COSIGN_MAX_TIME)
            require( (currentTime - mLastSpend[msg.sender]) > DAY_LENGTH);//, "You can't call this more than once per day per signature");
    require(currentTime - mLastSpend[msg.sender] > DAY_LENGTH);//, "You can't call this more than once per day per signature");
        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE1] < COSIGN_MAX_TIME)
        if (block.timestamp - mSignatures[CONTRACT_SIGNATURE2] < COSIGN_MAX_TIME)
            require(currentTime - mLastSpend[msg.sender] > DAY_LENGTH);//, "You can't call this more than once per day per signature");
