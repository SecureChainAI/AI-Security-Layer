pragma solidity ^0.4.24;

function claimTokens() public{
        require(activated);
        //progress the day if needed
        if(dayStartTime<now.sub(timestep)){
            uint daysPassed=(now.sub(dayStartTime)).div(timestep);
            dayStartTime=dayStartTime.add(daysPassed.mul(timestep));
            claimedYesterday=claimedToday > 1 ? claimedToday : 1; //make 1 the minimum to avoid divide by zero
            claimedToday=0;
        }