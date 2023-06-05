pragma solidity >= 0.5.13 <0.7.3;

contract InvestorLedger{
    
    address owner; 
    
    string public company_name;
    uint public founders;
    uint public funding_provided;
    uint public funding;
    
    
    constructor() public {
        owner = msg.sender;
    }
    
    function read_data(string memory _name, uint _founders, uint _amount, uint _funding) public{
        require(owner == msg.sender,"You are not authorised person.");
        company_name= _name;
        founders = _founders;
        funding_provided = _amount;
        funding = _funding;
    }
    
    function update_funding(uint _fund)  public{
        require(owner == msg.sender,"You are not authorised person.");
          funding_provided= _fund;
    }
    
}
