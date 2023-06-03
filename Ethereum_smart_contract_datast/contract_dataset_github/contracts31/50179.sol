pragma solidity >=0.7.0 <0.8.0;

contract Foo {
    
    Calculator calc = Calculator(0x790622c16aCFe9c7EfD39EDc5Ebcadf71e2ccd37);
    
    function treePlusTwo() public constant returns (int) {
        return calc.plus(3, 2);
    }
    
    function treeMultiplyTwo()  public constant returns (int) {
        return calc.multiply(3, 2);
    }
}

contract Calculator {
    
    function plus(int a, int b) public pure returns (int) {
        return a + b;
    }
    
    function multiply(int a, int b) public pure returns (int){
        return a * b;   
    }
}

