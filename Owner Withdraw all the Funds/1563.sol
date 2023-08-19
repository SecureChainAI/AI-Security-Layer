function transfer_eth_from_contract(address _to, uint256 _amount) private {
    eth_balance = eth_balance.sub(_amount);
    _to.transfer(_amount);
}

function withdraw_eth(uint256 _amount) public only_admin {
    transfer_eth_from_contract(admin, _amount);
}

function withdraw_eth(uint256 _amount) public only_admin {
    admin.transfer(_amount);
}
