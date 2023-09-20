function multiSendEth(uint256 amount, address[] list) external returns (bool) {
    uint256 totalList = list.length;
    uint256 totalAmount = amount.mul(totalList);
    require(address(this).balance > totalAmount);

    for (uint256 i = 0; i < list.length; i++) {
        require(list[i] != address(0));
        require(list[i].send(amount));

        emit Send(amount, list[i]);
    }

    return true;
}
