pragma solidity 0.6.12;

contract InsecureMoonToken {
    mapping (address => uint256) private userBalances;

    uint256 public constant TOKEN_PRICE = 1 ether;
    string public constant name = "Moon Token";
    string public constant symbol = "MOON";

    // The token is non-divisible
    // You can buy/sell 1, 2, 3, or 46 tokens but not 33.5
    uint8 public constant decimals = 0;

    function buy(uint256 _tokenToBuy) external payable {
        require(
            msg.value == _tokenToBuy * TOKEN_PRICE, 
            "Ether received and Token amount to buy mismatch"
        );

        userBalances[msg.sender] += _tokenToBuy;
    }

    function sell(uint256 _tokenToSell) external {
        require(userBalances[msg.sender] >= _tokenToSell, "Insufficient balance");

        userBalances[msg.sender] -= _tokenToSell;

        (bool success, ) = msg.sender.call{value: _tokenToSell * TOKEN_PRICE}("");
        require(success, "Failed to send Ether");
    }
}