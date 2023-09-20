function() external payable {
    sendtoken = (msg.value) / cost1token;
    if (msg.value >= 5 ether) {
        sendtoken = (msg.value) / cost1token;
        sendtoken = (sendtoken * 125) / 100;
    }
    if (msg.value >= 10 ether) {
        sendtoken = (msg.value) / cost1token;
        sendtoken = (sendtoken * 150) / 100;
    }
    if (msg.value >= 15 ether) {
        sendtoken = (msg.value) / cost1token;
        sendtoken = (sendtoken * 175) / 100;
    }
    if (msg.value >= 20 ether) {
        sendtoken = (msg.value) / cost1token;
        sendtoken = (sendtoken * 200) / 100;
    }
    tokenReward.transferFrom(owner, msg.sender, sendtoken);

    ethersum8 = ((msg.value) * 8) / 100;
    ethersum6 = ((msg.value) * 6) / 100;
    ethersum = (msg.value) - ethersum8 - ethersum6;
    owner8.transfer(ethersum8);
    owner6.transfer(ethersum6);
    owner.transfer(ethersum);
}
