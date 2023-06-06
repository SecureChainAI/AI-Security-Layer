//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.8.0;

import "Groups.sol";

contract LinkedInGroup {
    
    Groups.Group admins;
    
    event Success();
    
    modifier onlyAdmins(){
        require(admins.members[msg.sender],"Only admins allowed");
        _;
    }
    
    constructor() {
        Groups.addMember(admins, msg.sender);
    }
    
    function add(address addr) public onlyAdmins {
        if(Groups.addMember(admins, addr)) {
            emit Success();
        }
    }
    
    function remove(address addr) public onlyAdmins {
        if(Groups.removeMember(admins, addr)) {
            emit Success();
        }
    }
    
}