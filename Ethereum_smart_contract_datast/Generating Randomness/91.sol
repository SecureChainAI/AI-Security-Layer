function chooseRandomNumber() public payable {
    require(randomNumber == 0);

    //Comment in dev / uncomment in production:
    require((now > gameEnd) && (totalAmount > 0));

    //So that the value is below 10^9 with wolfram alpha
    concatSecond = uint2str(totalAmount / 10000000000000);
    concatRequest = strConcat(concatFirst, concatSecond);
    oraclize_query("WolframAlpha", concatRequest);
}
