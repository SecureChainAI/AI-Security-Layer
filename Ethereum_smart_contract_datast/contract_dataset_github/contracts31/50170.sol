// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

library Groups {
    
    struct Group {
        mapping (address => bool) members;
    }

    function addMember(Group storage self, address addr) public returns (bool) {
        if (self.members[addr]){
            return false;
        }
        self.members[addr] = true;
        return true;
    }

    function removeMember(Group storage self, address addr) public returns (bool) {
        if (!self.members[addr]){
            return false;
        }
        self.members[addr] = false;
        return true;
    }

}