function delegateConsume(
    uint256 nonce,
    uint256 fee,
    uint256 value,
    bytes32 challenge,
    DelegateMode mode,
    uint8 v,
    bytes32 r,
    bytes32 s
) public liquid canDelegate returns (bool) {
    require(value > 0);

    address signer;
    address relayer;
    if (mode == DelegateMode.PublicMsgSender) {
        signer = ecrecover(
            keccak256(
                abi.encodePacked(
                    this,
                    nonce,
                    fee,
                    value,
                    challenge,
                    mode,
                    address(0)
                )
            ),
            v,
            r,
            s
        );
        relayer = msg.sender;
    } else if (mode == DelegateMode.PublicTxOrigin) {
        signer = ecrecover(
            keccak256(
                abi.encodePacked(
                    this,
                    nonce,
                    fee,
                    value,
                    challenge,
                    mode,
                    address(0)
                )
            ),
            v,
            r,
            s
        );
        relayer = tx.origin;
    } else if (mode == DelegateMode.PrivateMsgSender) {
        signer = ecrecover(
            keccak256(
                abi.encodePacked(
                    this,
                    nonce,
                    fee,
                    value,
                    challenge,
                    mode,
                    msg.sender
                )
            ),
            v,
            r,
            s
        );
        relayer = msg.sender;
    } else if (mode == DelegateMode.PrivateTxOrigin) {
        signer = ecrecover(
            keccak256(
                abi.encodePacked(
                    this,
                    nonce,
                    fee,
                    value,
                    challenge,
                    mode,
                    tx.origin
                )
            ),
            v,
            r,
            s
        );
        relayer = tx.origin;
    } else {
        revert();
    }

    Account storage signerAccount = accounts[signer];
    // nonce
    require(nonce == signerAccount.nonce);
    emit IncreaseNonce(signer, signerAccount.nonce += 1);

    // guarded by Math
    signerAccount.balance = signerAccount.balance.sub(value.add(fee));
    // guarded by totalSupply
    totalSupply -= value;

    emit Consume(signer, value, challenge);
    emit Transfer(signer, address(0), value);
    // guarded by totalSupply
    if (fee != 0) {
        accounts[relayer].balance += fee;
        emit Transfer(signer, relayer, fee);
    }

    return true;
}
