        uint256 randNum = uint256(keccak256(abi.encodePacked(tokenId, blockHash))) % probabilityByRarity;
        if(randNum <= (feedingCounter * rarityMultiplier)){
