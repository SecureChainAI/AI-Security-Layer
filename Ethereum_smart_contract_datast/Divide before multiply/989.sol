pragma solidity ^0.4.24;
      uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
      withdrawWallet.transfer(weiAmount.mul(uint256(100).sub(withdrawCommission)).div(100));
      uint256 weiAmount = _value.mul(withdrawCommission).div(priceEthPerToken);
      withdrawWallet.transfer(weiAmount.mul(uint256(100).sub(withdrawCommission)).div(100));
    uint256 tokens = msg.value.mul(depositCommission).mul(priceEthPerToken).div(10000);
    uint256 lockTokens = tokens.mul(100).div(lockTokensPercent);
