function delegateTransferAndCall(
    uint256 nonce,
    uint256 fee,
    uint256 gasAmount,
    address to,
    uint256 value,
    bytes data,
    DelegateMode mode,
    uint8 v,
    bytes32 r,
    bytes32 s
) public liquid canDelegate returns (bool) {
    require(to != address(this));
    address signer;
    address relayer;
    if (mode == DelegateMode.PublicMsgSender) {
        signer = ecrecover(
            keccak256(
                abi.encodePacked(
                    this,
                    nonce,
                    fee,
                    gasAmount,
                    to,
                    value,
                    data,
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
                    gasAmount,
                    to,
                    value,
                    data,
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
                    gasAmount,
                    to,
                    value,
                    data,
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
                    gasAmount,
                    to,
                    value,
                    data,
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
    require(nonce == signerAccount.nonce);
    emit IncreaseNonce(signer, signerAccount.nonce += 1);

    signerAccount.balance = signerAccount.balance.sub(value.add(fee));
    accounts[to].balance += value;
    if (fee != 0) {
        accounts[relayer].balance += fee;
        emit Transfer(signer, relayer, fee);
    }

    if (!to.isAccount() && data.length >= 68) {
        assembly {
            mstore(add(data, 36), value)
            mstore(add(data, 68), signer)
        }
        if (to.call.gas(gasAmount)(data)) {
            emit Transfer(signer, to, value);
        } else {
            signerAccount.balance += value;
            accounts[to].balance -= value;
        }
    } else {
        emit Transfer(signer, to, value);
    }

    return true;
}
