pragma solidity ^0.4.19;

function withdrawERC20Tokens(
    address _addressOfToken,
    address _recipient,
    uint256 _value
) public onlyOwner returns (bool) {
    require(
        _addressOfToken != address(0) && _recipient != address(0) && _value > 0
    );
    ERCInterface token = ERCInterface(_addressOfToken);
    token.transfer(_recipient, _value);
    ERC20TokensWithdrawn(_addressOfToken, _recipient, _value);
    return true;
}

function setBonus(uint256 _newBonus) public onlyOwner returns (bool) {
    require(bonus != _newBonus);
    BonustChanged(bonus, _newBonus);
    bonus = _newBonus;
}

function withdrawEth(uint256 _eth) public returns (bool) {
    require(ethBalanceOf[msg.sender] >= _eth && _eth > 0);
    uint256 toTransfer = _eth;
    ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].sub(_eth);
    msg.sender.transfer(toTransfer);
    EthWithdrawn(msg.sender, toTransfer);
}

function issueRefunds(address[] _addrs) public onlyOwner returns (bool) {
    require(_addrs.length <= maxDropsPerTx);
    for (uint i = 0; i < _addrs.length; i++) {
        if (_addrs[i] != address(0) && ethBalanceOf[_addrs[i]] > 0) {
            uint256 toRefund = ethBalanceOf[_addrs[i]];
            ethBalanceOf[_addrs[i]] = 0;
            _addrs[i].transfer(toRefund);
            RefundIssued(_addrs[i], toRefund);
        }
    }
}
