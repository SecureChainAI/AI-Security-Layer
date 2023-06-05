pragma solidity >=0.4.23 <0.6.0;

interface BTCHTokenInterface {
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}