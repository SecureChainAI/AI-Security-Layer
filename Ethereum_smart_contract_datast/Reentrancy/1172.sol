function withdrawInBatch(
    address[] tokenList,
    address[] toAddressList,
    uint256[] amountList
) public onlyOwner {
    require(tokenList.length == toAddressList.length);
    require(toAddressList.length == amountList.length);

    for (uint i = 0; i < toAddressList.length; i++) {
        if (tokenList[i] == 0) {
            toAddressList[i].transfer(amountList[i]);
        } else {
            ERC20(tokenList[i]).transfer(toAddressList[i], amountList[i]);
        }
    }
}

function withdrawEtherInBatch(
    address[] toAddressList,
    uint256[] amountList
) public onlyOwner {
    require(toAddressList.length == amountList.length);

    for (uint i = 0; i < toAddressList.length; i++) {
        toAddressList[i].transfer(amountList[i]);
    }
}
