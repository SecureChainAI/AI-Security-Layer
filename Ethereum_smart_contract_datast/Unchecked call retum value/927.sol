function deploy(
    uint256 _tokenId,
    uint32 _locationId,
    uint256 _duration
) public onlyAccessDeploy returns (bool) {
    // The hero should be possessed by anybody.
    require(ownerOf(_tokenId) != address(0));

    var _heroInstance = tokenIdToHeroInstance[_tokenId];

    // The character should be avaiable.
    require(_heroInstance.availableAt <= now);

    _heroInstance.lastLocationId = _locationId;
    _heroInstance.availableAt = now + _duration;

    // As the hero has been deployed to another place, fire event.
    Deploy(msg.sender, _tokenId, _locationId, _duration);
}

function addExp(
    uint256 _tokenId,
    uint32 _exp
) public onlyAccessDeploy returns (bool) {
    // The hero should be possessed by anybody.
    require(ownerOf(_tokenId) != address(0));

    var _heroInstance = tokenIdToHeroInstance[_tokenId];

    var _newExp = _heroInstance.currentExp + _exp;

    // Sanity check to ensure we don't overflow.
    require(_newExp == uint256(uint128(_newExp)));

    _heroInstance.currentExp += _newExp;
}
