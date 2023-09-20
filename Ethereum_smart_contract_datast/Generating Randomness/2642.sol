function chooseRandomNumber() public payable {
    require(randomNumber == 0);

    //Comment in dev / uncomment in production:
    require((now > gameEnd) && (totalAmount > 0));

    concatSecond = uint2str(totalAmount);
    concatRequest = strConcat(concatFirst, concatSecond);
    oraclize_query("WolframAlpha", concatRequest);
}
