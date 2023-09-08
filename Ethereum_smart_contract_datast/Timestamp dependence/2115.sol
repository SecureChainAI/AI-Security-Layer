    require(_openingTime >= block.timestamp);
    return block.timestamp > closingTime;
