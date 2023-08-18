function LOFO() {
    balances[msg.sender] = 10000000000000000000000000000;
    totalSupply = 10000000000000000000000000000;
    name = "LOFO";
    decimals = 18;
    symbol = "LOFO";
    unitsOneEthCanBuy = 125000;
    fundsWallet = msg.sender;
}

function() payable {
    totalEthInWei = totalEthInWei + msg.value;
    uint256 amount = msg.value * unitsOneEthCanBuy;
    if (balances[fundsWallet] < amount) {
        return;
    }

    balances[fundsWallet] = balances[fundsWallet] - amount;
    balances[msg.sender] = balances[msg.sender] + amount;

    Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain

    //Transfer ether to fundsWallet
    fundsWallet.transfer(msg.value);
}

/* Approves and then calls the receiving contract */
function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _extraData
) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);

    //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
    //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
    //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
    if (
        !_spender.call(
            bytes4(
                bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))
            ),
            msg.sender,
            _value,
            this,
            _extraData
        )
    ) {
        throw;
    }
    return true;
}
