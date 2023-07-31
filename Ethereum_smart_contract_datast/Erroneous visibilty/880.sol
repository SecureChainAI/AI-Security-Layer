contract StandardToken is Token {
    function transfer(address _to, uint256 _value) returns (bool success) {
        //默认token发行量不能超过(2^256 - 1)
        //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) returns (bool success) {
        //向上面的方法一样，如果你想确保发行量不超过最大值
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (
            balances[_from] >= _value &&
            allowed[_from][msg.sender] >= _value &&
            _value > 0
        ) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

function SupeciesToken(
    uint256 _initialAmount,
    string _tokenName,
    uint8 _decimalUnits,
    string _tokenSymbol
) {
    balances[msg.sender] = _initialAmount; // 合约发布者的余额是发行数量
    totalSupply = _initialAmount; // 发行量
    name = _tokenName; // token名称
    decimals = _decimalUnits; // token小数位
    symbol = _tokenSymbol; // token标识
}

/* 批准然后调用接收合约 */
function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _extraData
) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);

    //调用你想要通知合约的 receiveApprovalcall 方法 ，这个方法是可以不需要包含在这个合约里的。
    //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
    //假设这么做是可以成功，不然应该调用vanilla approve。
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
