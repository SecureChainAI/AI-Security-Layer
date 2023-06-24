contract AirDropForERC223 {
    mapping(address => bool) public invalidAirDrop;

    address[] public arrayAirDropReceivers;

    function isValidAirDropForIndividual() public view returns (bool) {
        bool validNotStop = !stop;
        bool validAmount = getRemainingToken() >= airDropAmount;
        bool validPeriod = now >= startTime && now <= endTime;
        bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];
        return
            validNotStop &&
            validAmount &&
            validPeriod &&
            validReceiveAirDropForIndividual;
    }

    function receiveAirDrop() public {
        require(isValidAirDropForIndividual());

        // set invalidAirDrop of msg.sender to true
        invalidAirDrop[msg.sender] = true;

        // set msg.sender to the array of the airDropReceiver
        arrayAirDropReceivers.push(msg.sender);

        // execute transfer
        erc20.transfer(msg.sender, airDropAmount);

        emit LogAirDrop(msg.sender, airDropAmount);
    }
}
