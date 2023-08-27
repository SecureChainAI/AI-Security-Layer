function oraclize_newRandomDSQuery(
    uint _delay,
    uint _nbytes,
    uint _customGasLimit
) internal returns (bytes32) {
    if ((_nbytes == 0) || (_nbytes > 32)) throw;
    bytes memory nbytes = new bytes(1);
    nbytes[0] = bytes1(_nbytes);
    bytes memory unonce = new bytes(32);
    bytes memory sessionKeyHash = new bytes(32);
    bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
    assembly {
        mstore(unonce, 0x20)
        mstore(
            add(unonce, 0x20),
            xor(blockhash(sub(number, 1)), xor(coinbase, timestamp))
        )
        mstore(sessionKeyHash, 0x20)
        mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
    }
    bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
    bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
    oraclize_randomDS_setCommitment(
        queryId,
        sha3(bytes8(_delay), args[1], sha256(args[0]), args[2])
    );
    return queryId;
}
