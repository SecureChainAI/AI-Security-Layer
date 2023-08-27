function __callback(bytes32 myid, string result) {
    __callback(myid, result, new bytes(0));
}

function __callback(bytes32 myid, string result, bytes proof) {}

function Etheroll() {
    owner = msg.sender;
    treasury = msg.sender;
    oraclize_setNetwork(networkID_auto);
    /* use TLSNotary for oraclize call */
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    /* init 990 = 99% (1% houseEdge)*/
    ownerSetHouseEdge(990);
    /* init 10,000 = 1%  */
    ownerSetMaxProfitAsPercentOfHouse(10000);
    /* init min bet (0.1 ether) */
    ownerSetMinBet(100000000000000000);
    /* init gas for oraclize */
    gasForOraclize = 235000;
    /* init gas price for callback (default 20 gwei)*/
    oraclize_setCustomGasPrice(20000000000 wei);
}
