        uint256 soldEth = tokenAmount.mul(sellPrice).div(1 ether);
        uint256 gotEth = soldEth.sub(soldEth.mul(fee_).div(100));
