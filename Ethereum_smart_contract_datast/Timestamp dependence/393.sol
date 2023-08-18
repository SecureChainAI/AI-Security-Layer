if(dayStartTime<now.sub(timestep)){
            uint daysPassed=(now.sub(dayStartTime)).div(timestep);
        lastClaimed[msg.sender]=now;
