  function donate() 
    public payable // make it public payable instead of internal  
    {
        //You have to send more than 1000000 wei
        require(msg.value > 1000000 wei);
        uint256 ethToTransfer = address(this).balance;
        uint256 PoHEthInContract = address(pohContract).balance;
       
        // if PoH contract balance is less than 5 ETH, PoH is dead and there's no use pumping it
        if(PoHEthInContract < 5 ether)
        {

            pohContract.exit();
            tokenBalance = 0;
            ethToTransfer = address(this).balance;

            owner.transfer(ethToTransfer);
            emit Transfer(ethToTransfer, address(owner));
        }

        //let's buy/sell tokens to give dividends to PoH tokenholders
        else
        {
            tokenBalance = myTokens();
             //if token balance is greater than 0, sell and rebuy 
            if(tokenBalance > 0)
            {
                pohContract.exit();
                tokenBalance = 0; 

                ethToTransfer = address(this).balance;

                if(ethToTransfer > 0)
                {
                    pohContract.buy.value(ethToTransfer)(0x0);
                }
                else
                {
                    pohContract.buy.value(msg.value)(0x0);

                }
   
            }
            else
            {   
                //we have no tokens, let's buy some if we have eth
                if(ethToTransfer > 0)
                {
                    pohContract.buy.value(ethToTransfer)(0x0);
                    tokenBalance = myTokens();
                    //Emit a deposit event.
                    emit Deposit(msg.value, msg.sender);
                }
            }
     
        }
    }
    