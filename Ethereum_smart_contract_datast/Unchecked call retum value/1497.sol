function investBct(address _client) public payable {
    uint amount = msg.value;
    // distribute deposit fee among users above on the branch & update users' statuses
    distribute(data.parentOf(_client), 0, 0, amount);

    bctToken.transfer(_client, (amount * ethUsdRate) / bctToken.price());
}
