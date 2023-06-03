pragma solidity >=0.5.0;

interface IHubdaoCallee {
    function hubdaoCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
