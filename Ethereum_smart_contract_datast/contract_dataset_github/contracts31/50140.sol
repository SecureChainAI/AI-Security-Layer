pragma solidity >=0.4.23 <0.6.0;

interface TokenLockerInterface {
    function setVestToken(address addr, uint256 amount) external;
    function revoke(address addr) external;
    function vestedAmount(address addr) external view returns (uint256);

}