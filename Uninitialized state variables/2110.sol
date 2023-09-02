function getWinners(uint _blockNumber) public view returns (address[], uint[]) {
    uint _count = winners[_blockNumber].length;

    address[] memory _addresses = new address[](_count);
    uint[] memory _prize = new uint[](_count);

    uint _i = 0;
    for (_i = 0; _i < _count; _i++) {
        //_addresses[_i] = winners[_blockNumber][_i].addr;
        _prize[_i] = winners[_blockNumber][_i].prize;
    }

    return (_addresses, _prize);
}
