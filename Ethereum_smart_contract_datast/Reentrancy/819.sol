 function finalize() onlyOwner public {
        require(!isFinalized);
        // require(hasEnded());
        
        finalization();
        emit BrickFinalized();
        
        isFinalized = true;
    }