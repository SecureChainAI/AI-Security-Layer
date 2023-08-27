function getChild(
    address _from,
    uint256 _toTokenId,
    address _childContract,
    uint256 _childTokenId
) external {
    receiveChild(_from, _toTokenId, _childContract, _childTokenId);
    require(
        _from == msg.sender ||
            ERC721(_childContract).getApproved(_childTokenId) == msg.sender ||
            ERC721(_childContract).isApprovedForAll(_from, msg.sender),
        "msg.sender is not owner/operator/approved for child token."
    );
    ERC721(_childContract).transferFrom(_from, this, _childTokenId);
}
