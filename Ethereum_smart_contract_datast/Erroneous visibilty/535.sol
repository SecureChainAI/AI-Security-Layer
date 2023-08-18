function canCall(
    address _src,
    address _dst,
    bytes4 _sig
) constant returns (bool) {
    return ((_src == multisig || _src == crowdsale) &&
        _sig == bytes4(keccak256("mint(address,uint256)")));
}
