    function donate() 
    public payable 
    {
        //You have to send more than 1000000 wei
        //你必须发送超过1000000 wei
        require(msg.value > 1000000 wei);
        uint256 ethToTransfer = address(this).balance;
        uint256 PoCEthInContract = address(pocContract).balance;
       
        // if PoC contract balance is less than 5 ETH, PoC is dead and there is no reason to pump it
        // 如果PoC合同余额低于5 ETH，PoC已经死亡，没有理由将其泵出
        if(PoCEthInContract < 5 ether)
        {
            pocContract.exit();
            tokenBalance = 0;
            ethToTransfer = address(this).balance;

            owner.transfer(ethToTransfer);
            emit Transfer(ethToTransfer, address(owner));
        }

        // let's buy and sell tokens to give dividends to PoC tokenholders
        // 让我们买卖代币给PoC代币持有人分红
        else
        {
            tokenBalance = myTokens();

             // if token balance is greater than 0, sell and rebuy 
             // 如果令牌余额大于0，则出售并重新购买

            if(tokenBalance > 0)
            {
                pocContract.exit();
                tokenBalance = 0; 

                ethToTransfer = address(this).balance;

                if(ethToTransfer > 0)
                {
                    pocContract.buy.value(ethToTransfer)(0x0);
                }
                else
                {
                    pocContract.buy.value(msg.value)(0x0);
                }
            }
            else
            {   
                // we have no tokens, let's buy some if we have ETH balance
                // 我们没有代币，如果我们有ETH余额，我们就买一些
                if(ethToTransfer > 0)
                {
                    pocContract.buy.value(ethToTransfer)(0x0);
                    tokenBalance = myTokens();
                    emit Deposit(msg.value, msg.sender);
                }
            }
        }
    }