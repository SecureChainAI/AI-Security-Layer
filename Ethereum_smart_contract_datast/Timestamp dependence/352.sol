    require(block.timestamp >= openingTime && block.timestamp <= closingTime);
    closingTime = block.timestamp + 1;
    return block.timestamp > closingTime;
    return (openingTime < block.timestamp && block.timestamp < closingTime);
