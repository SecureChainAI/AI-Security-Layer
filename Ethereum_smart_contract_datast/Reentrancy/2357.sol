  function _withdraw (address _beneficiary, address _tokenAddr) internal {
        require(contractStage == CONTRACT_SUBMIT_FUNDS, "Cannot withdraw when contract is not CONTRACT_SUBMIT_FUNDS");
        Beneficiary storage b = beneficiaries[_beneficiary];
        if (_tokenAddr == 0x00) {
            _tokenAddr = defaultToken;
        }
        TokenAllocation storage ta = tokenAllocationMap[_tokenAddr];
        require ( (ethRefundAmount.length > b.ethRefund) || ta.pct.length > b.tokensClaimed[_tokenAddr] );

        if (ethRefundAmount.length > b.ethRefund) {
            uint256 pct = _toPct(b.balance,finalBalance);
            uint256 ethAmount = 0;
            for (uint i= b.ethRefund; i < ethRefundAmount.length; i++) {
                ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
            }
            b.ethRefund = ethRefundAmount.length;
            if (ethAmount > 0) {
                _beneficiary.transfer(ethAmount);
                emit EthRefunded(_beneficiary, ethAmount);
            }
        }
        if (ta.pct.length > b.tokensClaimed[_tokenAddr]) {
            uint tokenAmount = 0;
            for (i= b.tokensClaimed[_tokenAddr]; i< ta.pct.length; i++) {
                tokenAmount = tokenAmount.add(_applyPct(b.balance, ta.pct[i]));
            }
            b.tokensClaimed[_tokenAddr] = ta.pct.length;
            if (tokenAmount > 0) {
                require(ta.token.transfer(_beneficiary,tokenAmount));
                ta.balanceRemaining = ta.balanceRemaining.sub(tokenAmount);
                emit TokenWithdrawal(_beneficiary, _tokenAddr, tokenAmount);
            }
        }
    }
   function submitPool(uint256 weiAmount) public onlyAdmin noReentrancy {
        require(contractStage < CONTRACT_SUBMIT_FUNDS, "Cannot resubmit pool.");
        require(receiverAddress != 0x00, "receiver address cannot be empty");
        uint256 contractBalance = address(this).balance;
        if(weiAmount == 0){
            weiAmount = contractBalance;
        }
        require(minContribution <= weiAmount && weiAmount <= contractBalance, "submitted amount too small or larger than the balance");
        finalBalance = contractBalance;
        // transfer to upstream receiverAddress
        require(receiverAddress.call.value(weiAmount)
            .gas(gasleft().sub(5000))(),
            "Error submitting pool to receivingAddress");
        // get balance post transfer
        contractBalance = address(this).balance;
        if(contractBalance > 0) {
            ethRefundAmount.push(contractBalance);
        }
        contractStage = CONTRACT_SUBMIT_FUNDS;
        emit PoolSubmitted(receiverAddress, weiAmount);
    }
