function vote(uint256[] _votes) public {
    require(_votes.length == itemCount);
    require(now >= start && now < end);

    address voter = msg.sender;
    if (!voted[voter]) {
        voted[voter] = true;
        voters.push(voter);
    }

    for (uint256 i = 0; i < itemCount; i++) {
        require(
            _votes[i] >= voteItems[i].minValue &&
                _votes[i] <= voteItems[i].maxValue
        );
        voteItems[i].votes[voter] = _votes[i];
    }
}
