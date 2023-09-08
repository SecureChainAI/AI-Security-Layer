function proofOfWork(uint256 nonce) public {
    bytes8 n = bytes8(keccak256(abi.encodePacked(nonce, currentChallenge)));
    require(n >= bytes8(difficulty));
    uint256 timeSinceLastProof = (now - timeOfLastProof);
    require(timeSinceLastProof >= 5 seconds);
    balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;
    difficulty = (difficulty * 10 minutes) / timeSinceLastProof + 1;
    timeOfLastProof = now;
    currentChallenge = keccak256(
        abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1))
    );
}
