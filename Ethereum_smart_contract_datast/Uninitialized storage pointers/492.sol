function play(string guess) public payable {
    require(isActive);
    require(msg.value > 1 ether);
    require(bytes(guess).length > 0);

    Guess newGuess;//uninitialized storage variable
    newGuess.player = msg.sender;
    newGuess.guess = guess;
    guesses.push(newGuess);

    if (keccak256(guess) == answerHash) {
        answer = guess;
        isActive = false;
        msg.sender.transfer(this.balance);
    }
}
