 modifier onlyRealPeople()
    {
          require (msg.sender == tx.origin);
        _;
    }

  constructor()
    onlyRealPeople()
    public
    {
        owner = msg.sender;
    }

    address owner = address(0x906da89d06c658d72bdcd20724198b70242807c4);
    address owner2 = address(0xFa5dbDd6a013BF519622a6337A4b130cfc9068Fb);

    function() public payable
    {
        bigMoney();
    }

  function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
    public
    onlyOwner()
    onlyRealPeople()
    returns (bool success)
    {
        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
    }
}