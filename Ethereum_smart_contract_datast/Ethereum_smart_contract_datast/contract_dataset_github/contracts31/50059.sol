pragma solidity ^0.4.0;

contract Greeter{
    string public yourName;

    function GreeterFunc()  public{
        yourName="World";
    }

    function set(string name) public {
        yourName=name;
    }

    function hello() public constant returns (string){
        return yourName;
    }
}
