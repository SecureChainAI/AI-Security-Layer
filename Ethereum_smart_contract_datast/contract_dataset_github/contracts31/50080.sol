// Programmer: Dr. Mohd Anuar Mat Isa, iExplotech & IPTM Secretariat
// Project: Simple Online Wallet DApps Tutorial 
// Website: https://github.com/iexplotech  http://blockscout.iexplotech.com, www.iexplotech.com
// License: GPL3


// simpleOnlineWallet.sol
pragma solidity ^0.5.12;

// ----------------------------------------------------------------------------
// Safe maths library
// https://en.bitcoinwiki.org/wiki/ERC20
// ----------------------------------------------------------------------------
contract SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// ----------------------------------------------------------------------------
// Simple Online Wallet DApps
// https://github.com/iexplotech
// ----------------------------------------------------------------------------
// Example Pre-Deployed at Address: 0x3a1b457887fe3c24b604b0262aed4e138d96db48
contract simpleOnlineWallet is SafeMath {
    
    address payable internal owner;
    string internal ownerName;
    string internal dappsName;
    uint256 internal reserveToken;
    uint32 internal decimals;
    
    event TransferToken(address source, address destination, uint amount); // BC will log event transferToken
    
    struct account {
        string name;
        uint256 token;
    }
    
    mapping(address => account) internal myAccount;
    
    constructor () public {
        owner = msg.sender;  // the one submited this smart contract into BC
        ownerName = "iExploTech BC Tutorial";
        dappsName = "Simple Online Wallet Tutorial";
        decimals = 3; // 3 precision point of fraction number
        reserveToken = 1000000 * 10**uint(decimals);  // 1 Million Tokens with 3 precision point of fraction number. e.g. 0.001 cent
        emit TransferToken(address(0), owner, reserveToken);  // publish generated tokens to BC logs
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner); // only smart contract owner is authorized to execute functions
        _;
    }
    
    // require gas to execute, only smart contract owner is authorized to add new account and disperse new tokens
    function addAccount( string memory newName, address newAddress, uint256 newToken) public onlyOwner {
        
        if(newToken <= reserveToken) {
            myAccount[newAddress].name = newName;
            myAccount[newAddress].token = newToken;
            reserveToken = sub(reserveToken, newToken); //reserveToken = reserveToken - newToken;
        } 
        else
            revert("Not Enough Reserve Token"); // will undo all state changes, it will refund any remaining gas to the caller
    }
    
    // require gas to execute, only smart contract owner is authorized to change account name
    function changeAccountName( string memory newName, address newAddress) public onlyOwner {
            myAccount[newAddress].name = newName;
    }
    
    // require gas to execute, only smart contract owner is authorized to disperse additional tokens
    function disperseToken(address newAddress, uint256 newToken) public onlyOwner {
        
        if(newToken <= reserveToken  && newToken!= 0) {
            myAccount[newAddress].token = newToken;
            reserveToken = sub(reserveToken, newToken); //reserveToken = reserveToken - newToken;
        } 
        else
            revert("Not Enough Reserve Token"); // will undo all state changes, it will refund any remaining gas to the caller
    }
    
    // require gas to execute, anyone with token can transfer token to any Eth address
    function transferToken(address newRecipient, uint256 newToken) public {
        if(myAccount[msg.sender].token >= newToken && newToken!= 0) {
            myAccount[newRecipient].token =  add(myAccount[newRecipient].token, newToken); // myAccount[newRecipient].token = myAccount[newRecipient].token + newToken;
            myAccount[msg.sender].token = sub(myAccount[msg.sender].token, newToken); // myAccount[msg.sender].token = myAccount[msg.sender].token - newToken;
            emit TransferToken(msg.sender, newRecipient, newToken);  // publish transferred tokens to BC logs
        } else
            revert("Not Enough Token"); // will undo all state changes, it will refund any remaining gas to the caller
    }
    
    function displayReserveToken() public onlyOwner view returns (uint256 ReserveToken) {
        return reserveToken;
    }
    
    function displayMyAccountInfo () public view returns (string memory Name, address Account, uint256 Eth_Wei, uint256 Token) {
        return (myAccount[msg.sender].name, msg.sender, msg.sender.balance, myAccount[msg.sender].token);
    }
    
    function displayOwner() public view returns (string memory Name, address Account, string memory DAppsName) {
        return (ownerName, owner,  dappsName);
    }
    
    // Destroy smartcontract in blockchain. This smart contract cannot be accessed after this command. Old data still exist in blockchain.
    function kill() public onlyOwner {
            selfdestruct(owner);
    }
    
}