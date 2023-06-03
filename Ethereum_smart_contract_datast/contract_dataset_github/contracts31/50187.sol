// Programmer: Ts. Dr. Mohd Anuar Mat Isa, iExplotech & IPTM Secretariat
// Project: Sample Blockchain Based Voting/Pooling System
// Collaboration: Institusi Pendidikan Tinggi Malaysia (IPTM) Blockchain Testnet
// Website: https://github.com/iexplotech  http://blockscout.iexplotech.com, www.iexplotech.com
//"SPDX-License-Identifier: GPL3"

pragma solidity 0.6.12;

contract IPTM_Voting {
    
    event castedVote(address indexed Address, uint256 indexed Time);
    
    uint256 private totalVotes;
    uint256 private timeStart;
    uint256 private timeEnd;
    
    // for Debug (D)
    address private D_candidate_01;
    address private D_candidate_02;
    
    struct voter {
        string name;
        uint128 memberIC;
        uint128 memberID;
        bool voteCasted;  // true = summited vote, false = not submit yet.
    }
    
    struct candidate {
        string name;
        uint128 memberIC;
        uint128 memberID;
        uint256 candidateTotalVotes;
    }
    
    mapping (address => voter) private myVoter;
    mapping (address => candidate) private myCandidate;
    
    modifier timeLimit {
        if(now >= timeStart && now <=timeEnd) {
            _;
        } else
            revert("Time Out... No More Voting!");
    }
    
    constructor () public {
        totalVotes = 0;
        timeStart = now; // voting started immediately after contract posted into Blockchain
        timeEnd = timeStart + 60;  //voting ended after 60 seconds
        
        // This section for Debug (D)
        D_candidate_01 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; // Address JavaScript VM, Remix Ide
        D_candidate_02 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db; // Address JavaScript VM, Remix Ide
        D_setAllVoters();
        D_setAllCandidates();
    }
    
    function addVoter(string memory newName, uint128 newMemberIC, uint128 newMemberID)
        public {
        myVoter[msg.sender].name = newName;
        myVoter[msg.sender].memberIC = newMemberIC;
        myVoter[msg.sender].memberID = newMemberID;
        myVoter[msg.sender].voteCasted = false;
    }
    
    function addCandidate(string memory newName, uint128 newMemberIC, uint128 newMemberID)
        public {
        myCandidate[msg.sender].name = newName;
        myCandidate[msg.sender].memberIC = newMemberIC;
        myCandidate[msg.sender].memberID = newMemberID;
        myCandidate[msg.sender].candidateTotalVotes = 0;
    }
        
    function setVote() public {
        if(myVoter[msg.sender].voteCasted == false){
            totalVotes = totalVotes + 1;
            myVoter[msg.sender].voteCasted = true;
        }
    }
        
    function getTotalVotes() public view returns (uint256) {
        return totalVotes;
    }
    
    function getTotalCandidateVotes(address newAddress) public view returns (uint256) {
        return (myCandidate[newAddress].candidateTotalVotes);
    }
    
    
    // Debug/Testing functions
    function D_setVoter(address newAddress, string memory newName, uint128 newMemberIC, 
        uint128 newMemberID) public {
        myVoter[newAddress].name = newName;
        myVoter[newAddress].memberIC = newMemberIC;
        myVoter[newAddress].memberID = newMemberID;
        myVoter[newAddress].voteCasted = false;
    }
    
    function D_setAllVoters() public {
        D_setVoter(D_candidate_01, "V1", 11, 11); // voter 1 & Candidate01, Address JavaScript VM
        D_setVoter(D_candidate_02, "V2", 22, 22); // voter 2 & Candidate02, Address JavaScript VM
        D_setVoter(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, "V3", 33, 33); // voter 3, Address JavaScript VM
        D_setVoter(0x617F2E2fD72FD9D5503197092aC168c91465E7f2, "V4", 44, 44); // voter 4, Address JavaScript VM
        D_setVoter(0x17F6AD8Ef982297579C203069C1DbfFE4348c372, "V5", 55, 55); // voter 5, Address JavaScript VM
        D_setVoter(0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678, "V6", 66, 66); // voter 6, Address JavaScript VM
    }
    
    function D_addCandidate(address newAddress, string memory newName, uint128 newMemberIC, uint128 newMemberID)
        public {
        myCandidate[newAddress].name = newName;
        myCandidate[newAddress].memberIC = newMemberIC;
        myCandidate[newAddress].memberID = newMemberID;
        myCandidate[newAddress].candidateTotalVotes = 0;
    }
    
    function D_setAllCandidates() public {
        D_addCandidate(D_candidate_01, "Candidate01_Anuar", 11, 11); // Candidate 1, Anuar Isa
        D_addCandidate(D_candidate_02, "Candidate02_Anwar", 22, 22); // Candidate 2, Anwar Ibrahim
    }
    
    function D_chooseFirstCandidate() public timeLimit {
        if(myVoter[msg.sender].voteCasted == false){
            totalVotes = totalVotes + 1;
            myCandidate[D_candidate_01].candidateTotalVotes = myCandidate[D_candidate_01].candidateTotalVotes + 1;
            myVoter[msg.sender].voteCasted = true;
            
            emit castedVote(msg.sender, now);
        }
    }
    
    function D_chooseSecondCandidate() public timeLimit {
        if(myVoter[msg.sender].voteCasted == false){
            totalVotes = totalVotes + 1;
            myCandidate[D_candidate_02].candidateTotalVotes = myCandidate[D_candidate_02].candidateTotalVotes + 1;
            myVoter[msg.sender].voteCasted = true;
            
            emit castedVote(msg.sender, now);
        }
    }
    
    function D_getTotalCandidateVotes() public view returns (uint256, uint256) {
        return (myCandidate[D_candidate_01].
                    candidateTotalVotes, myCandidate[D_candidate_02].
                    candidateTotalVotes);
    }
}
