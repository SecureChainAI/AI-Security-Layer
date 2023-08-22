function oraclize_query(
    uint timestamp,
    string datasource,
    string[] argN
) internal returns (bytes32 id) {
    OraclizeI oracle = oraclize();
    uint price = oracle.getPrice(datasource);
    if (price > 1 ether + tx.gasprice * 200000) return 0; // unexpectedly high price
    bytes memory args = stra2cbor(argN);
    return oracle.queryN.value(price)(timestamp, datasource, args);
}
