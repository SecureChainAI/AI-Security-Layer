pragma solidity 0.6.2;

import "/@openzeppelin/contracts/access/Ownable.sol";



contract KycContract is Ownable {
    mapping(address => bool) allowed;

    function setKycCompleted(address _addr) public onlyOwner {
        allowed[_addr ] = true;
    }

    function setKycRevoked(address _addr ) public onlyOwner {
        allowed[_addr ] = false;
        
    }

}