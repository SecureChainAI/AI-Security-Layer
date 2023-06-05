pragma solidity >=0.4.23 <0.6.0;

interface ShakerTokenManagerInterface {
    function sendBonus(uint256 _amount, uint256 _decimals, uint256 _hours, address _depositer, address _withdrawer) external returns(bool);
    function sendRedpacketBonus(uint256 _amount, uint256 _decimals, uint256 _hours, address _depositer) external returns(bool);
    function getFee(uint256 _amount) external view returns(uint256);
}