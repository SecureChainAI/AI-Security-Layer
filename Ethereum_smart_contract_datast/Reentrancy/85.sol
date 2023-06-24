pragma solidity ^0.4.24;

function finalize() onlyOwner public {
        require(!isFinalized);
        // require(hasEnded());
        
        finalization();
        emit BrickFinalized();
        
        isFinalized = true;
    }
function finalization() internal {
         splitTokens();

        token.mint(wallet, totalTokens.sub(tokensIssuedTillNow));
        if(address(this).balance > 0){ // if any funds are left in contract.
            processFundsIfAny();
        }
    }
 function splitTokens() internal {   
        token.mint(techDevelopmentEthWallet, totalTokens.mul(3).div(100));          //wallet for tech development
        tokensIssuedTillNow = tokensIssuedTillNow + totalTokens.mul(3).div(100);
        token.mint(operationsEthWallet, totalTokens.mul(7).div(100));                //wallet for operations wallet
        tokensIssuedTillNow = tokensIssuedTillNow + totalTokens.mul(7).div(100);
        
    }
function processFundsIfAny() internal {
        
        require(advisoryEthWallet != address(0));
        require(infraEthWallet != address(0));
        require(techDevelopmentEthWallet != address(0));
        require(operationsEthWallet != address(0));
        
        operationsEthWallet.transfer(address(this).balance.mul(60).div(100));
        advisoryEthWallet.transfer(address(this).balance.mul(5).div(100));
        infraEthWallet.transfer(address(this).balance.mul(10).div(100));
        techDevelopmentEthWallet.transfer(address(this).balance.mul(25).div(100));
    }
    bool public isFinalized = false;
 function selfDestroy(address _address) public onlyOwner { // this method will send all money to the following address after finalize
        assert(isFinalized);
        selfdestruct(_address);
    }