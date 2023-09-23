function changeAdmin(address admin_) {
    if (msg.sender != admin) throw;
    admin = admin_;
}

function changeAccountLevelsAddr(address accountLevelsAddr_) {
    if (msg.sender != admin) throw;
    accountLevelsAddr = accountLevelsAddr_;
}

function changeFeeAccount(address feeAccount_) {
    if (msg.sender != admin) throw;
    feeAccount = feeAccount_;
}

function changeFeeMake(uint feeMake_) {
    if (msg.sender != admin) throw;
    feeMake = feeMake_;
}

function changeFeeTake(uint feeTake_) {
    if (msg.sender != admin) throw;
    if (feeTake_ < feeRebate) throw;
    feeTake = feeTake_;
}

function changeFeeRebate(uint feeRebate_) {
    if (msg.sender != admin) throw;
    if (feeRebate_ > feeTake) throw;
    feeRebate = feeRebate_;
}

function deposit() payable {
    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
    Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
}

function withdraw(uint amount) {
    if (tokens[0][msg.sender] < amount) throw;
    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
    if (!msg.sender.call.value(amount)()) throw;
    Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
}

function depositToken(address token, uint amount) {
    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
    if (token == 0) throw;
    if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
    tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
    Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
}

function withdrawToken(address token, uint amount) {
    if (token == 0) throw;
    if (tokens[token][msg.sender] < amount) throw;
    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
    if (!Token(token).transfer(msg.sender, amount)) throw;
    Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
}

function balanceOf(address token, address user) constant returns (uint) {
    return tokens[token][user];
}

function order(
    address tokenGet,
    uint amountGet,
    address tokenGive,
    uint amountGive,
    uint expires,
    uint nonce
) {
    bytes32 hash = sha256(
        this,
        tokenGet,
        amountGet,
        tokenGive,
        amountGive,
        expires,
        nonce
    );
    orders[msg.sender][hash] = true;
    Order(
        tokenGet,
        amountGet,
        tokenGive,
        amountGive,
        expires,
        nonce,
        msg.sender
    );
}

function trade(
    address tokenGet,
    uint amountGet,
    address tokenGive,
    uint amountGive,
    uint expires,
    uint nonce,
    address user,
    uint8 v,
    bytes32 r,
    bytes32 s,
    uint amount
) {
    //amount is in amountGet terms
    bytes32 hash = sha256(
        this,
        tokenGet,
        amountGet,
        tokenGive,
        amountGive,
        expires,
        nonce
    );
    if (
        !((orders[user][hash] ||
            ecrecover(
                sha3("\x19Ethereum Signed Message:\n32", hash),
                v,
                r,
                s
            ) ==
            user) &&
            block.number <= expires &&
            safeAdd(orderFills[user][hash], amount) <= amountGet)
    ) throw;
    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
    Trade(
        tokenGet,
        amount,
        tokenGive,
        (amountGive * amount) / amountGet,
        user,
        msg.sender
    );
}

function cancelOrder(
    address tokenGet,
    uint amountGet,
    address tokenGive,
    uint amountGive,
    uint expires,
    uint nonce,
    uint8 v,
    bytes32 r,
    bytes32 s
) {
    bytes32 hash = sha256(
        this,
        tokenGet,
        amountGet,
        tokenGive,
        amountGive,
        expires,
        nonce
    );
    if (
        !(orders[msg.sender][hash] ||
            ecrecover(
                sha3("\x19Ethereum Signed Message:\n32", hash),
                v,
                r,
                s
            ) ==
            msg.sender)
    ) throw;
    orderFills[msg.sender][hash] = amountGet;
    Cancel(
        tokenGet,
        amountGet,
        tokenGive,
        amountGive,
        expires,
        nonce,
        msg.sender,
        v,
        r,
        s
    );
}
