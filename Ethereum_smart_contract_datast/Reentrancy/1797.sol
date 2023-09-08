 function draw() private {
    require(now > roundEnds);
    uint256 howMuchBets = players.length;
    uint256 k;
    lastWinner = players[produceRandom(howMuchBets)];
    lastPayOut = getPayOutAmount();
   
    winners.push(lastWinner);
    if (winners.length > 9) {
      for (uint256 i = (winners.length - 10); i < winners.length; i++) {
        last10Winners[k] = winners[i];
        k += 1;
      }
    }
 
    payments.push(lastPayOut);
    payOuts[lastWinner] += lastPayOut;
    lastWinner.transfer(lastPayOut);
   
    players.length = 0;
    round += 1;
    amountRised = 0;
    roundEnds = now + roundDuration;
   
    emit NewWinner(lastWinner, lastPayOut);
  }
  function play() payable public {
    require (msg.value == playValue);
    require (!stopped);
 
    if (now > roundEnds) {
      if (players.length < 2) {
        roundEnds = now + roundDuration;
      } else {
        draw();
      }
    }
    players.push(msg.sender);
    amountRised = amountRised.add(msg.value);
  }