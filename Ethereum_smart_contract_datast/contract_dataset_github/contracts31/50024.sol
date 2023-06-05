// Programmer: Dr. Mohd Anuar Mat Isa, iExplotech & IPTM Secretariat
// Project: Sample Blockchain Based Electronic Certificate Verification System
// Collaboration: Institusi Pendidikan Tinggi Malaysia (IPTM) Blockchain Testnet
// Website: https://github.com/iexplotech  http://blockscout.iexplotech.com, www.iexplotech.com
//"SPDX-License-Identifier: GPL3"


pragma solidity ^0.6.12;

contract Privileged {
    
    address payable owner;  // submit smart contract, owner of this smart contract
    address IPTM_Verifier; // verify smart contract, only IPTM Secretariat can do this
    address registrar; // submit certificate info
    // msg.sender is the current user that run this smart contract, limited privilege
    
    bool verifiedSmartContract; // true if this smart contract passed verification by IPTM_Verifier
    
    modifier onlyOwner { // University
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyIPTM_Verifier { // Smart Contract Verifier: CyberSecurity Malaysia & iExploTech
        require(msg.sender == IPTM_Verifier);
        _;
    }
    
    modifier onlyRegistrar { // University
        require(msg.sender == registrar);
        _;
    }
    
    constructor () public {
        owner = msg.sender; // The one post this contract into Blockchain
        
        // Run on IPTM Blockchain
        IPTM_Verifier = 0x0000706E899d0f46c5EFE22c4CAaEb885af4dcAc;  // you may change to another address
        registrar  = owner; // you may change to another address
        
        verifiedSmartContract = false;
    }
    
    function whoAmI() public view returns (address) {
        return msg.sender; // msg.sender is the one that run the contract now!.. your account
    }
    
    function whoSmartContractVerifier() public view returns (address) {
        return IPTM_Verifier;
    }
    
    function whoOwner() public view returns (address) {
        return owner;
    }
    
    function setRegistrar(address newAddress) public onlyOwner {
        registrar = newAddress;
    }
    
    function whoRegistrar() public view returns (address) {
        return registrar;
    }
    
    function setSmartContractVerification (bool newStatus) public onlyIPTM_Verifier {
        verifiedSmartContract = newStatus;
    }
    
    function getSmartContractVerification () public view returns (bool)  {
        return verifiedSmartContract;
    }
    
    function kill() public onlyOwner {  // Terminate this contract
            selfdestruct(owner);
    }
}

contract IPTM_E_Certificate is Privileged {
    
    // Event Logs
    event addedNewCertInfo(address indexed Address, string Name, string Programme, 
                            string SemesterGraduate, string Convocation);                        
    event updatePersonalInfo(address indexed Address, string Name, string NRIC);

    // university
    struct certificate {
        string name;
        string programme;
        string semesterGraduate;
        string convocation;
    }
    
    struct personal {
        string name;
        string NRIC; // National Registration Identity Card
    }
    
    mapping (address=>certificate) internal gradCert;
    mapping (address=>personal) internal myPersonal;
    mapping (address=>bool) internal userUpdateRestriction;
    
    constructor () public {
        
    }
    
    // Only Registrar have permission to write cert info
    function setCertInfo(address newAddress, string memory newName, string memory  newProgramme, 
                            string memory  newSemesterGraduate, string memory  newConvocation) public onlyRegistrar {
        gradCert[newAddress].name = newName;
        gradCert[newAddress].programme = newProgramme;
        gradCert[newAddress].semesterGraduate = newSemesterGraduate;
        gradCert[newAddress].convocation = newConvocation;
        
        userUpdateRestriction[newAddress] = true; // lock user account form updating their Personal Info 
        
        emit addedNewCertInfo(newAddress, newName, newProgramme, newSemesterGraduate, newConvocation);
    }
    
    // Everyone can read cert info
    function getCertInfo(address newAddress) public view returns (string memory, string memory, 
                            string memory, string memory) {
        return(gradCert[newAddress].name, gradCert[newAddress].programme, gradCert[newAddress].semesterGraduate, 
                gradCert[newAddress].convocation);
    }
    
    // User can read their cert info
    function getMyCertInfo() public view returns (string memory, string memory, string memory, string memory) {
        return(gradCert[msg.sender].name, gradCert[msg.sender].programme, gradCert[msg.sender].semesterGraduate, 
                gradCert[msg.sender].convocation);
    }
    
    // Only User can write/update their Name & NIRC
    function setMyPersonalInfo(string memory newName, string memory newNRIC) public {
        
        if(userUpdateRestriction[msg.sender] == true) // revert() uses for rollback to original state & exit
            revert("You are no longer authorized to update you personal data. Certificate already generated!");  
        
        myPersonal[msg.sender].name = newName;
        myPersonal[msg.sender].NRIC= newNRIC;
        
        emit updatePersonalInfo(msg.sender, newName, newNRIC);
    }
    
    // User can read their Name & NIRC
    function getMyPersonalInfo() public view returns (string memory, string memory){
        return(myPersonal[msg.sender].name, myPersonal[msg.sender].NRIC);
    }
    
    function getPersonalInfo(address newAddress) public onlyRegistrar view returns (string memory, string memory){
        return(myPersonal[newAddress].name, myPersonal[newAddress].NRIC);
    }
    
    // Testing and Debuging Functions
    function setDebugPersonalInfo () public {
         setMyPersonalInfo("MOHD ANUAR BIN MAT ISA", "820716001234");
    }
    
    function setDebugCertInfo(address newAddress) public onlyRegistrar {
        setCertInfo(newAddress, "MOHD ANUAR BIN MAT ISA", "DOCTOR OF PHILOSOPHY IN ELECTRICAL ENGINEERING", "Session 1 2018/2019", "MARCH 2019");
    }
    
    function setDebugSmartContractVerification () public onlyIPTM_Verifier {
        setSmartContractVerification (true);
    }
}
