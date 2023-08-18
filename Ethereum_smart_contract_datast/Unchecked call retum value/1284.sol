function cancelDist() public {
    require(_fDist == true, "must dist"); // 必须发布
    require(_fCancelDist == false, "must not cancel dist");

    // 循环判断是否
    for (uint256 i = 0; i < _details.length; i++) {
        // 判断是否发行者
        if (_details[i].founder == msg.sender) {
            // 设置标志
            _details[i].isCancelDist = true;
            break;
        }
    }
    // 更新状态
    updateCancelDistFlag();
    if (_fCancelDist == true) {
        require(_erc20token.balanceOf(address(this)) > 0, "must have balance");
        // 返回所有代币给最高权限人
        _erc20token.transfer(_ownerDist, _erc20token.balanceOf(address(this)));
    }
}
