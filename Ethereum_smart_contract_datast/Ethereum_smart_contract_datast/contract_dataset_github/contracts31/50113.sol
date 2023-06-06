pragma solidity ^0.4.17;

contract ComercialSimple {
    
    uint public montoVentas;
    uint public montoMeta;
    
    function ComercialSimple() public {
        
    }
    
    function addMontoVenta(uint x) public {
        montoVentas = montoVentas + x;
    }
    
    function setMontoMeta(uint x) public {
        montoMeta = x;
    }
    
    function cumpleMenta() public view returns (bool) {
        if( montoVentas == montoMeta || montoVentas > montoMeta ){
            return true;
        }else{
            return false;
        }
    }
}