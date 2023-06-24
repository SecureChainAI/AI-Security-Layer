pragma solidity ^0.4.24;

function buy(
    IMultiToken _mtkn,
    uint256 _minimumReturn,
    ERC20 _throughToken,
    address[] _exchanges,
    bytes _datas,
    uint[] _datasIndexes, // including 0 and LENGTH values
    uint256[] _values
) public payable {
    require(
        _datasIndexes.length == _exchanges.length + 1,
        "buy: _datasIndexes should start with 0 and end with LENGTH"
    );
    require(
        _values.length == _exchanges.length,
        "buy: _values should have the same length as _exchanges"
    );

    for (uint i = 0; i < _exchanges.length; i++) {
        bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
        for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
            data[j - _datasIndexes[i]] = _datas[j];
        }

        if (_throughToken != address(0) && i > 0) {
            _throughToken.approve(_exchanges[i], _throughToken.balanceOf(this));
        }
        require(
            _exchanges[i].call.value(_values[i])(data),
            "buy: exchange arbitrary call failed"
        );
        if (_throughToken != address(0)) {
            _throughToken.approve(_exchanges[i], 0);
        }
    }

    j = _mtkn.totalSupply(); // optimization totalSupply
    uint256 bestAmount = uint256(-1);
    for (i = _mtkn.tokensCount(); i > 0; i--) {
        ERC20 token = _mtkn.tokens(i - 1);
        token.approve(_mtkn, token.balanceOf(this));

        uint256 amount = j.mul(token.balanceOf(this)).div(
            token.balanceOf(_mtkn)
        );
        if (amount < bestAmount) {
            bestAmount = amount;
        }
    }

    require(bestAmount >= _minimumReturn, "buy: return value is too low");
    _mtkn.bundle(msg.sender, bestAmount);
    if (address(this).balance > 0) {
        msg.sender.transfer(address(this).balance);
    }
}
