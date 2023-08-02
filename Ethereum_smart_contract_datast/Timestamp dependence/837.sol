        if(_position <= 800){
        require(champ.position <= 800); 
        require(champ.withdrawCooldown < block.timestamp); //isChampWithdrawReady
        require (myChamp.readyTime <= block.timestamp); /// Is champ ready to fight again?
