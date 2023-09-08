    return (uint256)(keccak256(abi.encodePacked(current_token_hash, last_deal_time))) % 100;
