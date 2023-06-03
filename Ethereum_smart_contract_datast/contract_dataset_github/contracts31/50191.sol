pragma solidity ^0.4.24;

contract Contrato2{
   uint public storedData;

   event DataStored (
      uint data
   );

   function Contrato2(uint initVal) public {
      storedData = initVal;
   }

   function set(uint x) public returns (uint value) {
      require(x < 100, "Value can not be over 100");
      storedData = x;

      emit DataStored(x);

      return storedData;
   }

   function get() public constant returns (uint retVal) {
      return storedData;
   }

   function query() public constant returns (uint retVal) {
      return storedData;
   }
}