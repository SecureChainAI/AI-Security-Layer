// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

interface IPawnSpace {
    function factory() external view returns (address);

    function nftToken() external view returns (address);

    function getOrders() external view returns (uint256[] memory);

    function getNotAcceptedOrders() external view returns (uint256[] memory);

    function getOrder(uint256 orderId)
        external
        view
        returns (
            uint256[] memory tokenIds,
            address owner,
            uint256 requestAmount,
            uint256 interest,
            uint256 period,
            uint256 additionalCollateral,
            address offeror,
            uint256 createdAt,
            uint256 offeredAt,
            uint256 paidBackAt,
            uint256 withdrewAt
        );

    function order(
        uint256[] calldata tokenIds,
        uint256 requestAmount,
        uint256 interest,
        uint256 period,
        uint256 additionalCollateral
    ) external returns (uint256 orderId);

    function burnOrder(uint256 orderId) external;

    function offer(uint256 orderId) external;

    function payBack(uint256 offerId) external;

    function withdraw(uint256 orderId) external;

    function initialize(
        address,
        address,
        address,
        address
    ) external;

    event MintOrder(
        address indexed sender,
        uint256 orderId,
        uint256[] tokenIds,
        uint256 requestAmount,
        uint256 interest,
        uint256 period,
        uint256 additionalCollateral,
        uint256 createdAt
    );
    event BurnOrder(address indexed sender, uint256 orderId);
    event Offer(address indexed sender, uint256 orderId, uint256 offeredAt);
    event Payback(address indexed sender, uint256 orderId, uint256 paidBackAt);
    event Withdraw(address indexed sender, uint256 orderId, uint256 withdrewAt);
}
