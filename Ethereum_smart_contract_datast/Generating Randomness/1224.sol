function postGood(bytes32 _preset, uint _price) public onlyOwner {
    require(DC.getGoodPreset(_preset) == "");
    uint _decision = uint(
        keccak256(keccak256(blockhash(block.number), _preset), now)
    ) % (_price);
    DC.setGood(_preset, _price, _decision);
    Decision(_decision, _preset);
}
