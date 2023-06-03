// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

interface IPawnFactory {
    event SpaceCreated(
        address indexed token,
        address space,
        uint256 length,
        address stableToken,
        address aToken,
        address lendingPool
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getSpace(address token) external view returns (address space);

    function allSpaces(uint256 index) external view returns (address space);

    function allSpacesLength() external view returns (uint256);

    function createSpace(address token) external returns (address space);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}
