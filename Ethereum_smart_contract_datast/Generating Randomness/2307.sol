function saveRN(uint _block) public {
    if (blockhash(_block) != 0x0)
        randomNumber[_block] = uint(blockhash(_block));
    if (randomNumber[_block] != 0) {
        // If the number is set.
        uint rewardToSend = reward[_block];
        reward[_block] = 0;
        msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
    }
}
