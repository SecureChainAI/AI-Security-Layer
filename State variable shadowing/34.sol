contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
}

contract GlobalGoldCashToken is owned, TokenERC20 {
    uint256 public decimals = 18;
    string public tokenName;
    string public tokenSymbol;
    uint minBalanceForAccounts;
}
